# jupyter lab server handling

# $server_dir = "$powershell_dir\jupyter_server"

function Get-JupyterLabURL { # returns the servers URLs => "jupyter lab list" lists all running servers
    param(
        [switch]$Verbose
    )
    # The Verbose parameter overrides the value of the $VerbosePreference variable for the current command.
    # Setting a preference variable in a function overrides the variable for the duration of the function.
    if ($Verbose) {$VerbosePreference = 'Continue'}

    # param([string]$process_or_job='process')
    # if ($process_or_job -notin 'process','job') {Write-Error "Expected 'process' or 'job', received '$process_or_job'"; return}
    # if ($process_or_job -eq 'job') { # get the URL from the job logs
    #     # remove all non running jobs with the name "jupyter_server"
    #     Get-Job | ? {($_.Name -eq 'jupyter_server') -and ($_.State -ne 'Running')} | Remove-Job
    #     # look for a job named "jupyter_server"
    #     if ('jupyter_server' -notin (Get-Job).Name)
    #         {Write-Error "No job running a jupyter server was found"; return}
    #     $jupyter_server_logs = Receive-Job -Name 'jupyter_server' -Keep
    # }
    # else { # get the URL from the jupyter_lab_server.txt file
    # }
    # # http://localhost:8888/lab?token=de8d04621f324839342a6a4fbcb13e8e7a8bfb9752658bbb
    # # 'http:\/\/localhost:[\d]{4}\/lab\?token=[\w]+'
    # if ($jupyter_server_logs -match 'http:\/\/localhost:[\d]{4}\/lab\?token=[\w]+')
    #     {$Matches.0} => does not work in the least bit, need to use [regex]
    # else {Write-Error 'Could not retrieve jupyter server URL from jupyter logs'}

    # run in job to not activate conda in current session
    # $server_list_job = Start-Job -ScriptBlock {. $using:profile -NoWriteHost; cda; jupyter lab list} | Wait-Job
    # $job_logs = Receive-job $server_list_job
    # Remove-Job -Job $server_list_job

    if ($Env:CONDA_DEFAULT_ENV -eq 'workenv') {$jupyter_lab_list_output = jupyter server list}
    else {cda; $jupyter_lab_list_output = jupyter server list; cdd}
    $url_regex_pattern = 'http://localhost:[\d]+/\?token=[\w]+'
    if ($jupyter_lab_list_output -match $url_regex_pattern) {
        $urls = ([regex]::matches($jupyter_lab_list_output, $url_regex_pattern)).Value
        Write-Verbose "Found $($urls.Count) jupyter lab servers currently running"
        return $urls
    }
    else {Write-Verbose 'Found 0 jupyter lab servers currently running'}
}

# function Jupyter-Lab {cda; cd $code; jupyter lab}
function Wrapper-JupyterLab {
    param(
        [string] $CondaVEnv = 'workenv',
        [string] $RootDir = $code,
        [switch] $HiddenProcess,
        [switch] $Job,
        [switch] $URL,
        [switch] $Force,
        [switch] $Kill,
        [switch] $Logs,
        [switch] $Verbose,
        [switch] $Silent
    )
    if ($Verbose) {
        $VerbosePreference_backup = $VerbosePreference
        $VerbosePreference = 'Continue'
    }
    if (!$Silent) {
        $InformationPreference_backup = $InformationPreference
        $InformationPreference = 'Continue'
    }
    else {Write-Verbose "'-Silent' flag set, not printing information stream to host"}
    # $VEnv, $RootDir, $process_or_job
    # check if a server is already running
    if ($Kill) {
        Write-Verbose "'-Kill' flag set, killing all jupyter servers"
        $InformationPreference = 'SilentlyContinue'
        Kill-JupyterLab
        return
    }
    $running_servers_urls = Get-JupyterLabURL 2> $null
    if ($Logs) {
        Write-Verbose "'-Logs' flag set, writing the logs of the jupyter_server currently running as a job"
        if ($running_servers_urls.Count -eq 0) {Write-Error 'No jupyter server is currently running'}
        else {Write-JobServerLogs}
        return
    }
    if ($running_servers_urls.Count -gt 0) {
        if ($URL) {
            Write-Verbose "'-URL' flag set, returning the list of all running servers"
            Write-Information 'List of jupyter servers currently running:'
            return $running_servers_urls
        }
        # give the choice to output URL, or start a new server anyways
        $choice = 2
        if ($Force) {
            Write-Verbose "'-Force' flag set, bypassing confirmation"
            $choice = 1
        }
        while ($choice -eq 2) {
            $choices_table = @{
                0 = 'Output &URL', 'Display the login URL of all the servers running.';
                1 = 'Start &New server', 'Start a new Jupyter Lab server.';
                2 = '&Suspend', 'Pause this command and enter a nested prompt. Type "exit" to resume.'
            }
            $choice = Confirmation-Prompt -Question 'A Jupyter Lab server is already running. Please advise:' -ChoicesTable $choices_table
            if ($choice -eq 2) {
                Write-Verbose "Entering nested prompt"
                # reset $VerbosePreference and $InformationPreference for the nested prompt
                if ($Verbose) {$VerbosePreference = $VerbosePreference_backup}
                if (!$Silent) {$InformationPreference = $InformationPreference_backup}
                $host.EnterNestedPrompt()
                if ($Verbose) {$VerbosePreference = 'Continue'}
                if (!$Silent) {$InformationPreference = 'Continue'}
            }
        }
    }
    else {
        if ($URL) {
            Write-Verbose "'-URL' flag set, returning the list of all running servers"
            Write-Information 'No jupyter server is currently running'
            return
        }
        # start a new server
        $choice = 1
    }
    switch ($choice) {
        0 {
            Write-Verbose "Returning the list of all running servers"
            Write-Information 'List of jupyter servers currently running:'
            return $running_servers_urls
        }
        1 {
            Write-Verbose "Starting a new jupyter lab server"
            Write-Verbose "Conda virtual environment used: '$CondaVEnv'"
            Write-Verbose "Root directory: '$RootDir'"
            $jupyer_lab_server_path = "$_powershell_dir\utils\jupyter_lab_server.ps1"
            $commmand_str = "& $jupyer_lab_server_path -VEnv $CondaVEnv -RootDir $RootDir"
            $args_list = "-NoProfile", "-Command", $commmand_str
            if ($HiddenProcess -and $Job) {Write-Error 'Both -HiddenProcess and -Job flags are set'; return}
            elseif (!($HiddenProcess -or $Job)) { # process
                Write-Verbose "Starting a new powershell process to host the server"
                Start-Process -FilePath "pwsh.exe" -ArgumentList $args_list -WindowStyle 'Minimized'
            }
            elseif ($HiddenProcess) {
                Write-Verbose "Starting a new hidden powershell process to host the server"
                Start-Process -FilePath "pwsh.exe" -ArgumentList $args_list -WindowStyle 'Hidden'
            }
            elseif ($Job) {
                Write-Verbose "Starting a new powershell job to host the server"
                # Start-Job -Name 'jupyter_server' -ScriptBlock {. $using:profile -S; cda -VEnv $using:CondaVEnv; cd $using:RootDir; jupyter lab}
                Start-Job -Name 'jupyter_server' -FilePath $jupyer_lab_server_path -ArgumentList $CondaVEnv, $RootDir
            }
            else {throw 'This should never be thrown'}
        }
        default {throw 'This should never be thrown'}
    }
}
New-Item -Path Alias:jupyter_lab -Value Wrapper-JupyterLab -Force > $null

# make a function to print the logs of the jupyter server when running in a job
function Write-JobServerLogs {
    $running_job_servers = Get-Job | ? {($_.Name -eq 'jupyter_server') -and ($_.State -eq 'Running')}
    if ($running_job_servers.Count -eq 0) {Write-Error 'No jupyter server is currently running'}
    elseif ($running_job_servers.Count -eq 1) {Receive-Job $running_job_servers -keep}
    else {
        $ofs = ", "
        $chosen_id = Read-Host "Multiple jupyter servers are running as jobs, please select one job ID ($($running_job_servers.Id)) (default is most recent)"
        if ($chosen_id -eq "") {$chosen_id = ($running_job_servers.Id | Measure-Object -Maximum).Maximum}
        Receive-Job -Id $chosen_id -keep
    }
}
New-Item -Path Alias:jl -Value Write-JobServerLogs -Force > $null

function Kill-JupyterLab { # kill all jupyter lab servers
    $port_regex_pattern = 'http://localhost:([\d]+)/\?token=[\w]+'
    Get-JupyterLabURL 2> $null | % {[regex]::matches($_, $port_regex_pattern).Groups} | ? {$_.Name -eq 1} | % {jupyter server stop $_.Value}
}

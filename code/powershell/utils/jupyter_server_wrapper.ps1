# jupyter lab server handling


function Get-JupyterLabURL { # returns the servers URLs => "jupyter lab list" lists all running servers
    [CmdletBinding()]
    param()
    # The Verbose parameter overrides the value of the $VerbosePreference variable for the current command.
    # Setting a preference variable in a function overrides the variable for the duration of the function.
    # if ($Verbose) {$VerbosePreference = 'Continue'}

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
    $urls = ([regex]::matches($jupyter_lab_list_output, $url_regex_pattern)).Value
    $PSCmdlet.WriteVerbose("Found $($urls.Count) jupyter lab servers currently running")
    return $urls
}


function Wrapper-JupyterLab {
    [CmdletBinding()]
    param(
        [string] $EnvConda = 'workenv',
        [string] $RootDir = $code,
        [switch] $HiddenProcess,
        [switch] $Job,
        [switch] $URL,
        [switch] $Force, # takes priority over $Confirm
        [switch] $Kill,
        [switch] $Logs,
        [switch] $Confirm,
        [switch] $WhatIf,
        [switch] $Silent
    )
    if ($Silent) {
        $PSCmdlet.WriteVerbose("'-Silent' flag set, not printing information stream to host")
        $InformationPreference_backup = $InformationPreference
        $InformationPreference = 'SilentlyContinue'
    }
    if ($Kill) {
        $PSCmdlet.WriteVerbose("'-Kill' flag set, killing all jupyter servers")
        # Kill-Jupyter -Force:$Force -Confirm:$Confirm -WhatIf:$WhatIf -Silent:$Silent
        if ($Force) {Kill-Jupyter -Force -WhatIf:$WhatIf -Silent:$Silent}
        else {Kill-Jupyter -Confirm -WhatIf:$WhatIf -Silent:$Silent}
        return
    }
    $running_servers_urls = Get-JupyterLabURL
    if ($Logs) {
        $PSCmdlet.WriteVerbose("'-Logs' flag set, writing the logs of the jupyter_server currently running as a job")
        if ($running_servers_urls.Count -eq 0) {
            # Write-Error 'No jupyter server is currently running'
            $Exception = [Exception]::new("No jupyter server is currently running")
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                "NoRunningServer",
                [System.Management.Automation.ErrorCategory]::InvalidOperation,
                # $TargetObject # usually the object that triggered the error, if possible
                $null
            )
            $PSCmdlet.WriteError($ErrorRecord)
        }
        else {Write-JobServerLogs}
        return
    }
    # check if a server is already running
    if ($running_servers_urls.Count -gt 0) {
        if ($URL) {
            $PSCmdlet.WriteVerbose("'-URL' flag set, returning the list of all running servers")
            # Write-Information 'List of jupyter servers currently running:'
            $PSCmdlet.WriteInformation('List of jupyter servers currently running:', '')
            return $running_servers_urls
        }
        # give the choice to output URL, or start a new server anyways
        if ($Force) {$choice = 1}
        else {$choice = 2}
        while ($choice -eq 2) {
            $choices_table = @{
                0 = 'Output &URL', 'Display the login URL of all the servers running.';
                1 = 'Start &New server', 'Start a new Jupyter Lab server.';
                2 = '&Suspend', 'Pause this command and enter a nested prompt. Type "exit" to resume.'
            }
            $choice = Confirmation-Prompt -Question 'A Jupyter Lab server is already running. Please advise:' -ChoicesTable $choices_table
            if ($choice -eq 2) {
                $PSCmdlet.WriteVerbose('Entering nested prompt')
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
            $PSCmdlet.WriteVerbose("'-URL' flag set, returning the list of all running servers")
            # Write-Information 'No jupyter server is currently running'
            $PSCmdlet.WriteInformation('No jupyter server is currently running', '')
            return
        }
        # start a new server
        $choice = 1
    }
    switch ($choice) {
        0 {
            $PSCmdlet.WriteVerbose('Returning the list of all running servers')
            $PSCmdlet.WriteInformation('List of jupyter servers currently running:', '')
            return $running_servers_urls
        }
        1 {
            $PSCmdlet.WriteVerbose('Starting a new jupyter lab server')
            $PSCmdlet.WriteVerbose("Conda virtual environment used: '${EnvConda}'")
            $PSCmdlet.WriteVerbose("Root directory: '${RootDir}'")
            if ($host.Version.Major -eq 5) {$pwsh_exe = 'powershell.exe'}
            else {$pwsh_exe = 'pwsh.exe'}
            $jupyer_lab_server_path = "${_powershell_dir}\utils\jupyter_lab_server.ps1"
            $commmand_str = "& ${jupyer_lab_server_path} -VEnv ${EnvConda} -RootDir ${RootDir}"
            $args_list = '-NoProfile', '-Command', $commmand_str
            if ($HiddenProcess -and $Job) {Write-Error 'Both -HiddenProcess and -Job flags are set'; return}
            elseif (!($HiddenProcess -or $Job)) { # process
                # if ($PSCmdlet.ShouldProcess("Starting a new powershell process to host the server", "Start a new powershell process to host the server?", ''))
                if (ShouldProcess-Yes-No -PSCmdlet:$PSCmdlet -Force:$Force -Confirm:$Confirm -ConfirmImpact 'Low' `
                    -ConfirmQuestion 'Start a new powershell process to host the server?' -WhatIf:$WhatIf `
                    -WhatIfMessage 'Starting a new powershell process to host the server') {
                    $PSCmdlet.WriteVerbose('Starting a new powershell process to host the server')
                    Start-Process -FilePath $pwsh_exe -ArgumentList $args_list -WindowStyle 'Minimized'
                }
            }
            elseif ($HiddenProcess) {
                # if ($PSCmdlet.ShouldProcess("Starting a new hidden powershell process to host the server", "Start a new hidden powershell process to host the server?", ''))
                if (ShouldProcess-Yes-No -PSCmdlet:$PSCmdlet -Force:$Force -Confirm:$Confirm -ConfirmImpact 'Low' `
                    -ConfirmQuestion 'Start a new hidden powershell process to host the server?' -WhatIf:$WhatIf `
                    -WhatIfMessage 'Starting a new hidden powershell process to host the server') {
                    $PSCmdlet.WriteVerbose('Starting a new hidden powershell process to host the server')
                    Start-Process -FilePath $pwsh_exe -ArgumentList $args_list -WindowStyle 'Hidden'
                }
            }
            elseif ($Job) {
                # if ($PSCmdlet.ShouldProcess("Starting a new powershell job to host the server", "Start a new powershell job to host the server?", ''))
                if (ShouldProcess-Yes-No -PSCmdlet:$PSCmdlet -Force:$Force -Confirm:$Confirm -ConfirmImpact 'Low' `
                    -ConfirmQuestion 'Start a new powershell job to host the server?' -WhatIf:$WhatIf -WhatIfMessage 'Starting a new powershell job to host the server') {
                    $PSCmdlet.WriteVerbose('Starting a new powershell job to host the server')
                    # Start-Job -Name 'jupyter_server' -ScriptBlock {. $using:profile -S; cda -VEnv $using:EnvConda; cd $using:RootDir; jupyter lab}
                    Start-Job -Name 'jupyter_server' -FilePath $jupyer_lab_server_path -ArgumentList $EnvConda, $RootDir
                }
            }
            else {throw 'This should never be thrown'}
        }
        default {throw 'This should never be thrown'}
    }
}
New-Item -Path Alias:jupyter_lab -Value Wrapper-JupyterLab -Force > $null


function Write-JobServerLogs { # print the logs of the jupyter server when running in a job
    [CmdletBinding()]
    param()
    $running_job_servers = Get-Job | ? {($_.Name -eq 'jupyter_server') -and ($_.State -eq 'Running')}
    if ($running_job_servers.Count -eq 0) {
        # Write-Error 'No jupyter server is currently running'
        $Exception = [Exception]::new("No jupyter server is currently running as a job")
        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
            $Exception,
            "NoRunningServerJob",
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            # $TargetObject # usually the object that triggered the error, if possible
            $null
        )
        $PSCmdlet.WriteError($ErrorRecord)
    }
    elseif ($running_job_servers.Count -eq 1) {
        $PSCmdlet.WriteVerbose('Found a single running server as a job')
        Receive-Job $running_job_servers -keep
    }
    else {
        $PSCmdlet.WriteVerbose('Found multiple running servers as jobs')
        $ofs = ', '
        $chosen_id = Read-Host "Multiple jupyter servers are running as jobs, please select one job ID ($($running_job_servers.Id)) (default is most recent)"
        if ($chosen_id -eq '') {$chosen_id = ($running_job_servers.Id | Measure-Object -Maximum).Maximum}
        Receive-Job -Id $chosen_id -keep
    }
}
New-Item -Path Alias:jl -Value Write-JobServerLogs -Force > $null

# need to work:
# Kill-Jupyter-New -Port 8888, 8889 => kill servers running at port 8888 and 8889
# 8888, 8889 | Kill-Jupyter-New     => kill servers running at port 8888 and 8889
# Kill-Jupyter-New                  => kill all servers

# Kill-Jupyter-New -Port 8888, 8889
# => $Port = @(8888, 8889) in begin, process and end

# 8888, 8889 | Kill-Jupyter-New
# => $Port is null in being, is 8888 for a loop and 8889 for another in process,
# and is 8889 in end

# Kill-Jupyter-New
# => $Port is null in begin, process and end

function Kill-Jupyter {
    # TODO: implement -Silent
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(ValueFromPipeline)] [int[]] $Port,
        [switch] $Force,
        [switch] $Silent
    )
    begin {
        if ($Force -and ($ConfirmPreference -ne 'None')) {
            $PSCmdlet.WriteVerbose("'-Force' flag set, bypassing confirmation")
            $ConfirmPreference = 'None'
        }
        $port_regex_pattern = 'http://localhost:([\d]+)/\?token=[\w]+'
        if ($Env:CONDA_DEFAULT_ENV -eq 'workenv') {$conda_deactivate = $False}
        else {$PSCmdlet.WriteVerbose('Activating workenv for the command'); $conda_deactivate = $True; cda}
        $active_ports = Get-JupyterLabURL | ? {$_} | % {[regex]::matches($_, $port_regex_pattern).Groups} `
            | ? {$_.Name -eq 1} | % {$_.Value}
        # Write-Host $active_ports
    }
    process {
        if ($Port.Count -eq 0) {
            $PSCmdlet.WriteVerbose('no port specified, killing all servers')
            $active_ports | ? {$PSCmdlet.ShouldProcess(
                "Killing the server running at the '${_}' port",
                "Kill the server running at the '${_}' port ?",
                ''
            )} | % {jupyter server stop $_}
        }
        else {
            foreach ($port_number in $Port) {
                $PSCmdlet.WriteVerbose("killing the server running at the port ${port_number}")
                $active_ports | ? {[int] $_ -eq $port_number} | ? {$PSCmdlet.ShouldProcess(
                    "Killing the server running at the '${_}' port",
                    "Kill the server running at the '${_}' port ?",
                    ''
                )} | % {jupyter server stop $_}
            }
        }
    }
    end {
        if ($conda_deactivate) {cdd}
    }
}

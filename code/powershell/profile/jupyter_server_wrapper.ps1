# jupyter lab server handling

# $server_dir = "$powershell_dir\jupyter_server"

function Get-JupyterLabURL { # returns the servers URLs => "jupyter lab list" lists all running servers
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

    # => maybe remembering conda env would be faster?
    $current_conda_env = $Env:CONDA_DEFAULT_ENV
    if ($current_conda_env -eq 'workenv') {$jupyter_lab_list_output = jupyter lab list}
    else {cda; $jupyter_lab_list_output = jupyter lab list; cdd}
    $url_regex_pattern = 'http:\/\/localhost:[\d]+\/\?token=[\w]+'
    if ($jupyter_lab_list_output -match $url_regex_pattern) {
        ([regex]::matches($jupyter_lab_list_output, $url_regex_pattern)).Value
    }
    else {Write-Output 'Jupyter lab is not currently running'}
}

# function Jupyter-Lab {cda; cd $code; jupyter lab}
function Wrapper-JupyterLab {
    param(
        [string] $Venv = 'workenv',
        [string] $RootDir = $code,
        [string] $ProcessOrJob = 'process',
        [switch] $URL
    )
    # $Venv, $RootDir, $process_or_job
    # check if a server is already running
    $running_servers = Get-JupyterLabURL 2> $null
    # if (!$?) {}
    # if ($URL) {return $running_servers}
    if ($running_servers.Length -gt 0) {
        if ($URL) {return $running_servers}
        # give the choice to output URL, or start a new server anyways
        $choice = 2
        while ($choice -eq 2) {
            $choices_table = @{
                0 = 'Output &URL', 'Display the login URL of all the servers running.';
                1 = 'Start &New server', 'Start a new Jupyter Lab server.';
                2 = '&Suspend', 'Pause this command and enter a nested prompt. Type "exit" to resume.'
            }
            $choice = Confirmation-Prompt -Question 'A Jupyter Lab server is already running. Please advise:' -ChoicesTable $choices_table
            if ($choice -eq 2) {$host.EnterNestedPrompt()}
        }
    }
    else {
        if ($URL) {Write-Output 'Jupyter lab is not currently running'; return}
        # start a new server
        $choice = 1
        }
    switch ($choice) {
        0 {$running_servers}
        1 {
            # run either a new process or a new job
            if ($ProcessOrJob -eq 'process') {
                # $command_str = "& '$server_dir\jupyter_server.ps1' -Venv $Venv -RootDir $RootDir"
                # Start-Process -FilePath "pwsh.exe" -ArgumentList ("-c " + $command_str) -WindowStyle 'Minimized'
                Start-Process -FilePath "pwsh.exe" -ArgumentList "-c", "&", "$powershell_dir\jupyter_server.ps1", $Venv, $RootDir -WindowStyle 'Minimized'
            }
            elseif ($ProcessOrJob -eq 'job') {
                Start-Job -Name 'jupyter_server' -ScriptBlock {. $using:profile; cda -Venv $using:Venv; cd $using:RootDir; jupyter lab}
            }
            else {Write-Error "Expected 'process' or 'job', received '$ProcessOrJob'"; return}
        }
        default {throw 'smth went wrong'}
    }
    # Start-Job -Name 'jupyter_server' -ScriptBlock {. $using:profile; cda -Venv $using:Venv; cd $using:RootDir; jupyter lab}
}
New-Item -Path Alias:jupyter_lab -Value Wrapper-JupyterLab -Force > $null

# jupyter_lab_kill
# > if a file named "jupyter_lab_server.JSON" exists in the .jupyter directory in $HOME and it is not empty:
# >     remove it

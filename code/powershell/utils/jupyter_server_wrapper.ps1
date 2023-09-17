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

    if ($Env:CONDA_DEFAULT_ENV -eq $default_conda_venv) {$jupyter_lab_list_output = jupyter server list}
    else {cda; $jupyter_lab_list_output = jupyter server list; cdd}
    $url_regex_pattern = 'http://localhost:[\d]+/\?token=[\w]+'
    $urls = ([regex]::matches($jupyter_lab_list_output, $url_regex_pattern)).Value
    $PSCmdlet.WriteVerbose("Get-JupyterLabURL: Found $($urls.Count) jupyter lab server(s) currently running")
    $PSCmdlet.WriteObject($urls)
}


function Wrapper-JupyterLab {
    [CmdletBinding()]
    param(
        [string] $EnvConda = $default_conda_venv,
        [string] $RootDir = $default_dir,
        [switch] $HiddenProcess,
        [switch] $Job,
        [switch] $URL,
        [switch] $Force, # does not take priority over $Confirm, sets $ConfirmPreference to None
        [switch] $Kill,
        [switch] $Logs,
        [switch] $Confirm, # takes priority over $Force, sets $ConfirmPreference to Low
        [switch] $WhatIf,
        [switch] $Silent
    )
    if ($Silent) {
        $PSCmdlet.WriteVerbose("Wrapper-JupyterLab: '-Silent' flag set, not printing information stream to host")
        $InformationPreference_backup = $InformationPreference
        $InformationPreference = 'SilentlyContinue'
    }
    if ($Confirm) {
        $PSCmdlet.WriteVerbose("Wrapper-JupyterLab: '-Confirm' flag set, prompting for confirmation")
        $ConfirmPreference_backup = $ConfirmPreference
        $ConfirmPreference = 'Low'
    }
    elseif ($Force) {
        $PSCmdlet.WriteVerbose("Wrapper-JupyterLab: '-Force' flag set, bypassing confirmation")
        $ConfirmPreference_backup = $ConfirmPreference
        $ConfirmPreference = 'None'
    }
    # Write-Host 'Wrapper-JupyterLab $ConfirmPreference', $ConfirmPreference
    if ($Kill) {
        $PSCmdlet.WriteVerbose("Wrapper-JupyterLab: '-Kill' flag set, killing all jupyter servers")
        Kill-Jupyter -WhatIf:$WhatIf -Force:$Force
        return
    }
    $running_servers_urls = Get-JupyterLabURL
    if ($Logs) {
        $PSCmdlet.WriteVerbose("Wrapper-JupyterLab: '-Logs' flag set, writing the logs of the jupyter_server currently running as a job")
        if ($running_servers_urls.Count -eq 0) {
            # Write-Error 'No jupyter server is currently running'
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                [System.InvalidOperationException] 'No jupyter server is currently running',
                'NoRunningServer',
                [System.Management.Automation.ErrorCategory]::InvalidOperation,
                # $TargetObject # usually the object that triggered the error, if possible
                $null
            )
            $PSCmdlet.ThrowTerminatingError($ErrorRecord)
        }
        Get-JobServerLogs
        return
    }
    # check if a server is already running
    if ($running_servers_urls.Count -gt 0) {
        if ($URL) {
            $PSCmdlet.WriteVerbose("Wrapper-JupyterLab: '-URL' flag set, returning the list of all running servers")
            $PSCmdlet.WriteInformation('Wrapper-JupyterLab: List of jupyter servers currently running:', '')
            $PSCmdlet.WriteObject($running_servers_urls)
            return
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
                $PSCmdlet.WriteVerbose('Wrapper-JupyterLab: Entering nested prompt')
                # reset $InformationPreference and $ConfirmPreference for the nested prompt
                # Write-Host 'Wrapper-JupyterLab $InformationPreference', $InformationPreference
                # Write-Host 'Wrapper-JupyterLab $ConfirmPreference', $ConfirmPreference
                if ($Silent) {$InformationPreference = $InformationPreference_backup}
                if ($Confirm) {$ConfirmPreference = $ConfirmPreference_backup}
                $Host.EnterNestedPrompt()
                if ($Silent) {$InformationPreference = 'SilentlyContinue'}
                if ($Confirm) {$ConfirmPreference = 'Low'}
                # Write-Host 'Wrapper-JupyterLab $InformationPreference', $InformationPreference
                # Write-Host 'Wrapper-JupyterLab $ConfirmPreference', $ConfirmPreference
            }
        }
    }
    else {
        if ($URL) {
            $PSCmdlet.WriteVerbose("Wrapper-JupyterLab: '-URL' flag set, returning the list of all running servers")
            $PSCmdlet.WriteInformation('Wrapper-JupyterLab: No jupyter server is currently running', '')
            return
        }
        # start a new server
        $choice = 1
    }
    switch ($choice) {
        0 {
            $PSCmdlet.WriteVerbose('Wrapper-JupyterLab: Returning the list of all running servers')
            $PSCmdlet.WriteInformation('Wrapper-JupyterLab: List of jupyter servers currently running:', '')
            return $running_servers_urls
        }
        1 {
            $PSCmdlet.WriteVerbose('Wrapper-JupyterLab: Starting a new jupyter lab server')
            $PSCmdlet.WriteVerbose("Wrapper-JupyterLab: Conda virtual environment used: '${EnvConda}'")
            $PSCmdlet.WriteVerbose("Wrapper-JupyterLab: Root directory: '${RootDir}'")
            if ($Host.Version.Major -eq 5) {$pwsh_exe = 'powershell.exe'}
            else {$pwsh_exe = 'pwsh.exe'}
            $jupyer_lab_server_path = "${_powershell_dir}\utils\jupyter_lab_server.ps1"
            $commmand_str = "& ${jupyer_lab_server_path} -VEnv ${EnvConda} -RootDir ${RootDir}"
            $args_list = '-NoProfile', '-Command', $commmand_str
            if ($HiddenProcess -and $Job) {
                # Write-Error 'Both -HiddenProcess and -Job flags are set'
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.ArgumentException] 'Both -HiddenProcess and -Job flags are set',
                    'InvalidFlags',
                    [System.Management.Automation.ErrorCategory]::InvalidArgument,
                    # $TargetObject # usually the object that triggered the error, if possible
                    $null
                )
                $PSCmdlet.ThrowTerminatingError($ErrorRecord)
            }
            elseif (!($HiddenProcess -or $Job)) { # process
                # if ($PSCmdlet.ShouldProcess("Starting a new powershell process to host the server", "Start a new powershell process to host the server?", ''))
                if (ShouldProcess-Yes-No -PSCmdlet $PSCmdlet -Confirm:$Confirm -ConfirmImpact 'Low' `
                    -ConfirmQuestion 'Start a new powershell process to host the server?' -WhatIf:$WhatIf `
                    -WhatIfMessage 'Wrapper-JupyterLab: Starting a new powershell process to host the server') {
                    $ConfirmPreference = 'None'
                    Start-Process -FilePath $pwsh_exe -ArgumentList $args_list -WindowStyle 'Minimized'
                }
            }
            elseif ($HiddenProcess) {
                # if ($PSCmdlet.ShouldProcess("Starting a new hidden powershell process to host the server", "Start a new hidden powershell process to host the server?", ''))
                if (ShouldProcess-Yes-No -PSCmdlet $PSCmdlet -Confirm:$Confirm -ConfirmImpact 'Low' `
                    -ConfirmQuestion 'Start a new hidden powershell process to host the server?' -WhatIf:$WhatIf `
                    -WhatIfMessage 'Wrapper-JupyterLab: Starting a new hidden powershell process to host the server') {
                    $ConfirmPreference = 'None'
                    Start-Process -FilePath $pwsh_exe -ArgumentList $args_list -WindowStyle 'Hidden'
                }
            }
            elseif ($Job) {
                # if ($PSCmdlet.ShouldProcess("Starting a new powershell job to host the server", "Start a new powershell job to host the server?", ''))
                if (ShouldProcess-Yes-No -PSCmdlet $PSCmdlet -Confirm:$Confirm -ConfirmImpact 'Low' `
                    -ConfirmQuestion 'Start a new powershell job to host the server?' -WhatIf:$WhatIf `
                    -WhatIfMessage 'Wrapper-JupyterLab: Starting a new powershell job to host the server') {
                    $ConfirmPreference = 'None'
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


function Get-JobServerLogs { # print the logs of the jupyter server when running in a job
    [CmdletBinding()]
    param()
    $running_job_servers = Get-Job | ? {($_.Name -eq 'jupyter_server') -and ($_.State -eq 'Running')}
    if ($running_job_servers.Count -eq 0) {
        # Write-Error 'No jupyter server is currently running'
        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException] 'No jupyter server is currently running as a job',
            'NoRunningServerJob',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            # $TargetObject # usually the object that triggered the error, if possible
            $null
        )
        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
    }
    if ($running_job_servers.Count -eq 1) {
        $PSCmdlet.WriteVerbose('Get-JobServerLogs: Found a single running server as a job')
        Receive-Job $running_job_servers -keep
    }
    else {
        $PSCmdlet.WriteVerbose('Get-JobServerLogs: Found multiple running servers as jobs')
        $OFS = ', '
        $chosen_id = Read-Host "Get-JobServerLogs: Multiple jupyter servers are running as jobs, please select one job ID ($($running_job_servers.Id)) (default is most recent)"
        if ($chosen_id -eq '') {$chosen_id = ($running_job_servers.Id | Measure-Object -Maximum).Maximum}
        Receive-Job -Id $chosen_id -keep
    }
}
# New-Item -Path Alias:jl -Value Get-JobServerLogs -Force > $null

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
    # TODO: implement -Silent => impossible, cannot suppress jupyter server output
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(ValueFromPipeline)] [int[]] $Port,
        [switch] $Force # does not take priority over $Confirm, sets $ConfirmPreference to None
    )
    begin {
        # Write-Host 'Kill-Jupyter $ConfirmPreference', $ConfirmPreference
        if ($Confirm) {
            $PSCmdlet.WriteVerbose('Kill-Jupyter: $Confirm is on')
            $ConfirmPreference = 'Low'
        }
        elseif ($Force) {
            $PSCmdlet.WriteVerbose("Kill-Jupyter: '-Force' flag set, bypassing confirmation")
            $ConfirmPreference = 'None'
        }
        # Write-Host 'Kill-Jupyter $ConfirmPreference', $ConfirmPreference
        $port_regex_pattern = 'http://localhost:(\d+)/\?token=\w+'
        if ($Env:CONDA_DEFAULT_ENV -eq 'workenv') {$conda_deactivate = $False}
        else {
            $PSCmdlet.WriteVerbose('Kill-Jupyter: Activating workenv for the command')
            $conda_deactivate = $True
            cda
        }
        $active_ports = Get-JupyterLabURL | ? {$_} | % {[regex]::matches($_, $port_regex_pattern).Groups} `
            | ? {$_.Name -eq 1} | % {$_.Value}
        # Write-Host $active_ports
    }
    process {
        if ($Port.Count -eq 0) {
            $PSCmdlet.WriteVerbose('Kill-Jupyter: No port specified, killing all servers')
            $active_ports | ? {$PSCmdlet.ShouldProcess(
                "Kill-Jupyter: Killing the server running at the '${_}' port",
                "Kill the server running at the '${_}' port ?",
                ''
            )} | % {jupyter server stop $_}
        }
        else {
            foreach ($port_number in $Port) {
                $PSCmdlet.WriteVerbose("Kill-Jupyter: Killing the server running at the '${port_number}' port")
                $active_ports | ? {[int] $_ -eq $port_number} | ? {$PSCmdlet.ShouldProcess(
                    "Kill-Jupyter: Killing the server running at the '${_}' port",
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

# maybe restrict to a single command at a time => disallow strings containing ";" ?
# need to work:
# sudo echo "lol"
# sudo echo '"lol"'
# sudo '"lol"'
# sudo echo "'lol'"
# sudo "'lol'"
# sudo Write-Output "This is a 'great' message"
# sudo Write-Error "this is not good"
# sudo echo "This is a `"great`" message with 'both' kinds of quotes"
# sudo 1 + 2
# sudo echo $(34 + 70)
# sudo iex "`$Host.Version.Major" (=> 7)
# sudo -s iex "`$Host.Version.Major" (=> 5)
# => require interaction with the admin shell:
# => sudo Read-Host "test read host"
# => sudo pause

# => in cmd.exe: gotta escape every double quote characters
# pwsh.exe -Command echo '\"lol\"' => "lol"
# pwsh.exe -Command echo \"'lol'\" => 'lol'
# pwsh.exe -Command echo \"This is a 'great' string\" => This is a 'great' string
# pwsh.exe -Command echo 'This is a \"great\" string' => This is a "great" string
# pwsh.exe -Command echo \"This is a `\"great`\" message with 'both' kinds of quotes\" => This is a "great" message with 'both' kinds of quotes

# (pwsh.exe -Command echo 'This is a \"great\" string') in cmd.exe == (pwsh.exe -Command "echo 'This is a `"great`" string'") in pwsh.exe == (echo 'This is a "great" string') in pwsh.exe
# => make a .bat file ?
# {pwsh.exe -Command echo 'This is a \"great\" string' & pause} | Out-File -FilePath '.\sudo.bat'
# {pwsh.exe -Command echo 'This is a \"great\" string'; pause; Get-WinEvent -LogName security; pause} | Out-File -FilePath '.\sudo.bat'
# start-Process -FilePath '.\sudo.bat' -Verb 'RunAs'

# ps buffer line scanning:
# > start sudo process
# > $last_read_time = 0
# > $index_last_line_printed = -1
# > while the process has not exited:
# >     if current_time >= $last_read_time + 1s:
# >         $index_line = 0
# >         foreach ($line in $(read $_ps_buffer)) {
# >             if ($index_line > $index_last_line_printed) {
# >                 Write-Host $sudo_output_prefix $line
# >                 $index_last_line_printed = $index_line
# >             }
# >             ++$index_line
# >         }
# >         $last_read_time = current_time
# >     sleep 0.1s

# seconds until epoch:
# (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds

function Run-AsAdmin {
    # convert into cmdlet ? => bad idea: common parameters will bloat the function call

    # if sudo is called in an terminal with admin privileges, run the command directly
    if (Test-Path -Path 'Env:\_PROMPT_PRIVILEGE') {
        Invoke-Expression "${args}"
        return
    }

    # create/clear sudo.bat and ps_buffer.txt
    $bat_script_path = "${_powershell_dir}\utils\sudo.bat"
    Out-File -FilePath $bat_script_path
    Out-File -FilePath $_ps_buffer

    $cmd_prompt_args = @()
    foreach ($arg in $args) {
        if (($arg -is [System.String]) -and ($arg -match '[ ''"]')) {
            # if a string argument contains either spaces or quotes,
            # replace all '"' with '`\"', and add '\"' at both ends
            $cmd_prompt_args += '\"' + ($arg -replace '"', '`\"') + '\"'
        }
        else {$cmd_prompt_args += [string] $arg}
    }

    # make a .bat file (.\sudo.bat)
    # $cmd_prompt_args is a list of strings
    # pwsh.exe -Command echo 'This is a \"great\" string'; pause; Get-WinEvent -LogName security; pause
    # $bat_file_content = "pwsh.exe -Command Start-Transcript -Path $_ps_buffer; ''; '[SUDO]' + '$('~'*50)'; ''; $cmd_prompt_args; ''; '$('~'*56)'; ''; Stop-Transcript; pause;"
    if ($Host.Version.Major -eq 5) {
        $pwsh_exe = 'powershell.exe'
        # PS5 encodes in "UTF8 with BOM", which doesn't work with cmd prompt
        $encoding = 'ASCII'
    }
    else {
        $pwsh_exe = 'pwsh.exe'
        $encoding = 'UTF8'
    }
    $cwd = (Get-Location).Path
    # if the current location path ends with a "\" (drive root), add another to escape it
    if ($cwd[-1] -eq '\') {$cwd += '\'}
    $bat_file_content = "${pwsh_exe} -NoProfile -Command . `$PROFILE -Silent; cd \`"${cwd}\`"; ${cmd_prompt_args} > `"${_ps_buffer}`""
    $bat_file_content | Out-File -FilePath $bat_script_path -Encoding $encoding

    # try {Start-Process -FilePath $bat_script_path -Verb 'RunAs' -WindowStyle 'Minimized' -PassThru | Wait-Process}
    try {$sudo_process = Start-Process -FilePath $bat_script_path -Verb 'RunAs' -WindowStyle 'Minimized' -PassThru}
    catch [System.InvalidOperationException] {
        Write-Error "The operation was canceled by the user"
        return
    }
    catch {
        Write-Error "Error:"
        $PSItem | select *
        return
    }

    $sudo_output_prefix = "[$($colors_table.bcol_Blue)ADMIN$($colors_table.col_def)]"
    # scan $_ps_buffer every second until the process is over
    $last_read_time = 0
    $index_last_line_printed = -1
    while (-not $sudo_process.HasExited) {
        $seconds_since_epoch = (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds
        if ($seconds_since_epoch -ge $($last_read_time + 1)) {
            $index_line = 0
            foreach ($line in $(read $_ps_buffer)) {
                if ($index_line -gt $index_last_line_printed) {
                    # strip ending whitespaces before printing the line
                    Write-Host $sudo_output_prefix ($line -replace ' *$', '')
                    $index_last_line_printed = $index_line
                }
                ++$index_line
            }
            $last_read_time = $seconds_since_epoch
            # if any line was printed ...
            if ($index_last_line_printed -ge 0) {
                # place the cursor at the start of the last line printed
                $cursor_pos = $Host.UI.RawUI.Cursorposition
                [Console]::SetCursorPosition(0, $cursor_pos.Y - 1)
                # decrement index_last_line_printed
                --$index_last_line_printed
            }
        }
        Start-Sleep .2
    }
    # scan $_ps_buffer one last time before exiting
    $index_line = 0
    foreach ($line in $(read $_ps_buffer)) {
        if ($index_line -gt $index_last_line_printed) {
            # strip ending whitespaces before printing the line
            Write-Host $sudo_output_prefix ($line -replace ' *$', '')
            $index_last_line_printed = $index_line
        }
        ++$index_line
    }
}
New-Item -Path Alias:sudo -Value Run-AsAdmin -Force | Out-Null

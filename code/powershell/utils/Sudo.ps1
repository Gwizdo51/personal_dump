# maybe restrict to a single command at a time => disallow strings containing ";" ?
# need to work:
# sudo echo "lol"
# sudo Write-Output "This is a 'great' message"

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

# regex replace:
# 'This is a "Great" string' -replace '"', '\"'

# sudo Write-Output 'This is a "great" message' => args = 'Write-Output', 'This is a "great" message'
# > for each $arg in $args:
# >     if the arg is a string:
# >         if it has spaces:
# >             add '\"' at the beginning and at the end
# >             replace '"' with '`\"'
# >         else: add as is
# >     else: add it as a string

# sudo Write-Output "This is a 'great' message" => args = 'Write-Output', 'This is a "great" message'

function Run-AsAdmin {
    # run command in current session if it has admin rights

    # /!\ cant use:
    # - quotes, double-quotes (sudo strips everything, but sometimes fucky wucky)
    # - multiple commands in a row (';' disallowed)
    # => maybe store command in file, not send it as string?

    # replace all '"' with '\"'
    $processed_args = @()
    foreach ($arg in $args) {
        # $arg
        if ((type $arg) -eq 'System.String') {
            if ($arg -match ' ') {
                $processed_arg = $arg -replace '"', '`\"'
                $processed_args += '\"' + $processed_arg + '\"'
            }
            else {$processed_args += $arg}
        }
        else {$processed_args += [string] $arg}
        # $processed_args[-1]
    }
    # return
    # return $processed_args
    # return {$processed_args}

    # # Start-Process -FilePath 'pwsh.exe' -ArgumentList "-NoExit", "-NonInteractive", "-Command", "echo lol" -Verb 'RunAs'
    # # $args_list = "-NoProfile", "-Command", '. $profile -Silent; echo lol; while ($true) {sleep 1}'
    # # $command_string = ". `$profile -Silent; '$('-'*27)'; $args | Out-File -FilePath $powershell_dir\profile\ps_buffer.txt; '$('-'*27)'; pause"
    # $command_string = ". `$profile -Silent; '$('-'*27)'; Start-Transcript -Path $powershell_dir\profile\ps_buffer.txt | Out-Null;"
    # $command_string += " $args; Stop-Transcript | Out-Null; '$('-'*27)'; Write-Host ''; pause;"
    # # Write-Host $command_string
    # # $args_list = '-NoProfile', '-Command', $command_string
    # Write-Host $args_list
    # # return

    # make a .bat file (.\sudo.bat)
    # $processed_args is a list of strings
    # pwsh.exe -Command echo 'This is a \"great\" string'; pause; Get-WinEvent -LogName security; pause
    # $bat_file_content = "pwsh.exe -Command ''; '$('-'*27)'; $processed_args; '$('-'*27)'; ''; pause;"
    $bat_file_content = "pwsh.exe -Command Start-Transcript -Path $_ps_buffer; ''; '[SUDO]' + '$('~'*50)'; ''; $processed_args; ''; '$('~'*56)'; ''; Stop-Transcript; pause;"
    # return $bat_file_content
    $bat_script_path = "$_powershell_dir\utils\sudo.bat"
    $bat_file_content | Out-File -FilePath $bat_script_path
    # return

    # try {Start-Process -FilePath 'pwsh.exe' -ArgumentList $args_list -Verb 'RunAs' -PassThru | Wait-Process}
    # try {Start-Process -FilePath 'pwsh.exe' -ArgumentList $args_list -PassThru | Wait-Process}
    # try {Start-Process -FilePath $bat_script_path -PassThru | Wait-Process}
    try {Start-Process -FilePath $bat_script_path -Verb 'RunAs' -PassThru | Wait-Process}
    catch [System.InvalidOperationException] {
        # $PSItem | select *
        Write-Error "The operation was canceled by the user"
        return
    }
    catch {"another error"; return}
    # return

    $ps_buffer_lines = read $_ps_buffer
    # only print what is after [SUDO]~~~ and before ~~~
    $sudo_output = @()
    $is_sudo_output = $False
    foreach ($line in $ps_buffer_lines) {
        if ($line -eq '[SUDO]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~') {
            $is_sudo_output = $True
        }
        elseif ($line -eq '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~') {
            $is_sudo_output = $False
        }
        elseif ($is_sudo_output) {$sudo_output += $line}
    }
    if ($sudo_output.Count -gt 2) {$sudo_output[1..($sudo_output.Count - 2)] | % {'[ADMIN]: ' + $_}}

    # empty sudo.bat and ps_buffer.txt
    # Out-File -FilePath $bat_script_path
    # Out-File -FilePath $_ps_buffer
}
New-Item -Path Alias:sudo -Value Run-AsAdmin -Force > $null

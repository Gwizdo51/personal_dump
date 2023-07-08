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
# sudo iex "`$host.Version.Major" (=> 7)
# sudo -s iex "`$host.Version.Major" (=> 5)
# => require interaction with the admin shell:
# => sudo read-host "test read host"
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

function Run-AsAdmin {
    # convert into cmdlet ?
    param ([switch]$SystemPS)
    # pass "-s" to use powershell.exe instead of pwsh.exe (slightly faster, it seems)

    # create/clear sudo.bat and ps_buffer.txt
    $bat_script_path = "$_powershell_dir\utils\sudo.bat"
    Out-File -FilePath $bat_script_path
    Out-File -FilePath $_ps_buffer

    $cmd_prompt_args = @()
    foreach ($arg in $args) {
        # $arg
        if (((type $arg) -eq 'System.String') -and ($arg -match '[ ''"]')) {
            # if a string argument contains either spaces or quotes,
            # replace all '"' with '`\"', and add '\"' at both ends
            $cmd_prompt_args += '\"' + ($arg -replace '"', '`\"') + '\"'
        }
        else {$cmd_prompt_args += [string] $arg}
        # $cmd_prompt_args[-1]
    }
    # return
    # return $cmd_prompt_args
    # return {$cmd_prompt_args}

    # make a .bat file (.\sudo.bat)
    # $cmd_prompt_args is a list of strings
    # pwsh.exe -Command echo 'This is a \"great\" string'; pause; Get-WinEvent -LogName security; pause
    # $bat_file_content = "pwsh.exe -Command Start-Transcript -Path $_ps_buffer; ''; '[SUDO]' + '$('~'*50)'; ''; $cmd_prompt_args; ''; '$('~'*56)'; ''; Stop-Transcript; pause;"
    if (($host.Version.Major -eq 5) -or ($SystemPS)) {
        $pwsh_exe = 'powershell.exe'
        $sudo_output_prefix = "[$($colors_table.bcol_Blue)SYSADMIN$($colors_table.col_def)]"
    }
    else {
        $pwsh_exe = 'pwsh.exe'
        $sudo_output_prefix = "[$($colors_table.bcol_Blue)ADMIN$($colors_table.col_def)]"
    }
    $bat_file_content = "$pwsh_exe -NoProfile -Command .  \`"`$profile\`" -Silent; cd \`"$(Get-Location)\`"; $cmd_prompt_args > $_ps_buffer"
    # return $bat_file_content
    $bat_file_content | Out-File -FilePath $bat_script_path -Encoding 'ascii' # need to add encoding because ps5 is a dumbass
    # return

    # try {Start-Process -FilePath 'pwsh.exe' -ArgumentList $args_list -Verb 'RunAs' -PassThru | Wait-Process}
    # try {Start-Process -FilePath 'pwsh.exe' -ArgumentList $args_list -PassThru | Wait-Process}
    # try {Start-Process -FilePath $bat_script_path -PassThru | Wait-Process}
    try {Start-Process -FilePath $bat_script_path -Verb 'RunAs' -WindowStyle 'Minimized' -PassThru | Wait-Process}
    catch [System.InvalidOperationException] {Write-Error "The operation was canceled by the user"; return}
    catch {"another error"; $PSItem | select *; return}
    # return

    # read $_ps_buffer | % {"[$($colors_table.bcol_Blue)ADMIN$($colors_table.col_def)] " + $_}
    foreach ($line in $(read $_ps_buffer)) {Write-Host $sudo_output_prefix $line}

    # empty sudo.bat and ps_buffer.txt
    # Out-File -FilePath $bat_script_path
    # Out-File -FilePath $_ps_buffer
}
New-Item -Path Alias:sudo -Value Run-AsAdmin -Force > $null

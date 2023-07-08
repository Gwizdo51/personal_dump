param([switch]$Silent, [switch]$Verbose)
$tick = Get-Date

# set up output and input shell encoding to UTF-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# setting $InformationPreference to 'Continue' for the profile load, unless $Silent is on
if (!$Silent) {
    $InformationPreference_backup = $InformationPreference
    $InformationPreference = 'Continue'
}
if ($Verbose) {
    $VerbosePreference_backup = $VerbosePreference
    $VerbosePreference = 'Continue'
}

# if (!$NoWriteHost) {Write-Host "Loading personal profile (custom_profile.ps1) ..."}
Write-Information "Loading personal profile (custom_profile.ps1)..."


#############
### CONDA ###
#############

# <#
Write-Verbose 'Setting up Conda ...'
$Env:_CONDA_ROOT = "$HOME\anaconda3"
$Env:CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
$Env:_CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList @{ChangePs1 = $False} -Verbose:$False
# conda activate base
#>


##############
### PROMPT ###
##############

Write-Verbose 'Setting up prompt colors...'
function _gen_colors_hashtable {
    function gen_color_char {param ([int]$color_char_number); "$([char]27)[$($color_char_number)m"}
    $colors_table = @{} # empty hashtable
    $colors_table['col_def'] = gen_color_char 0
    # $($col_Black)  $($col_Red)  $($col_Green)  $($col_Yellow)  $($col_Blue)  $($col_Magenta)  $($col_Cyan)  $($col_White)
    # $($bcol_Black) $($bcol_Red) $($bcol_Green) $($bcol_Yellow) $($bcol_Blue) $($bcol_Magenta) $($bcol_Cyan) $($bcol_White)
    $i = 30
    foreach ($color_name in 'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White') {
        $reg_col_var_name = "col_$color_name"
        $reg_col_var_value = gen_color_char $i
        $colors_table["$reg_col_var_name"] = $reg_col_var_value
        $bri_col_var_name = "bcol_$color_name"
        $bri_col_var_value = gen_color_char $($i + 60)
        $colors_table["$bri_col_var_name"] = $bri_col_var_value
        ++$i
    }
    return $colors_table
}
$colors_table = _gen_colors_hashtable
# function Prompt-Git-Branch-Name {
function _gen_git_prompt {
    # look for possible branch name, silence git "not in git repo" error
    $branch = $(& "C:\Program Files\Git\cmd\git.exe" rev-parse --abbrev-ref HEAD 2> $null)
    if ($branch -eq $null) {return} # not in a git repo, don't return anything
    if ($branch -eq 'HEAD') { # we're in detached HEAD state, so print the SHA
        "($($colors_table.col_Red)$(& "C:\Program Files\Git\cmd\git.exe" rev-parse --short HEAD)$($colors_table.col_def))"
    }
    else { # we're on an actual branch, so print it
        "($($colors_table.col_Blue)$($branch)$($colors_table.col_def))"
    }
}
function Alias-CD {
    param([string]$DirPath)
    # (todo: fail if $DirPath is not a directory)
    Set-Location $DirPath
    if ($(Get-Location).drive.provider.name -eq 'FileSystem') {
        # we are in a FileSystem drive, safe to look for git branches
        $Env:_PROMPT_GIT_MODIFIER = $(_gen_git_prompt)
    }
    else {
        # we are not in a FileSystem drive, clear $Env:_PROMPT_GIT_MODIFIER
        $Env:_PROMPT_GIT_MODIFIER = $null
    }
    # put the git prompt in $Env
    # $Env:_PROMPT_GIT_MODIFIER = git_branch_name
}
# override "cd" alias with cd_alias
New-Item -Path Alias:cd -Value Alias-CD -Force > $null
function Alias-GIT {
    # call git
    & "C:\Program Files\Git\cmd\git.exe" $args
    # udpate $Env:_PROMPT_GIT_MODIFIER
    cd .
}
# override "git" alias with git_alias
New-Item -Path Alias:git -Value Alias-GIT -Force > $null
function _gen_privilege_prompt { # add "[ADMIN]" to the prompt if the shell is opened as admin
    $principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    $admin_role = [Security.Principal.WindowsBuiltInRole]::Administrator
    if ($principal.IsInRole($admin_role)) {$ENV:_PROMPT_PRIVILEGE = "$($colors_table.col_def)[$($colors_table.bcol_Blue)ADMIN$($colors_table.col_def)] "}
}
_gen_privilege_prompt
function Prompt {
    # "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
    ### /!\ CANNOT CALL A FUNCTION IN ANY WAY INSIDE PROMPT /!\ ###
    # if we want to keep the "turn red on error" feature (from PSReadLine)
    # => needs to receive state from Env, like conda
    # check if a conda venv is activated, if so color only the venv name
    if ($Env:CONDA_PROMPT_MODIFIER -match '\(([\w\- ]+)\)') # => use [regex] instead, more robust
        {$conda_prompt = "($($colors_table.col_Cyan)$($Matches.1)$($colors_table.col_def))`n"}
    else
        {$conda_prompt = ''}
    $git_prompt = [string] $Env:_PROMPT_GIT_MODIFIER
    # default ("[int][char]'>'" to find the integer): [char]62
    # here: [int][char]'¤' => 164
    # '>' => 62
    # $dynamic_color_char = [char] 12903
    # $char_0 = [char] 12903
    $char_0 = [char] 12295
    # $char_0 = [char] 124
    # $char_1 = [char] 65376
    # $char_1 = [char] 9002
    $char_1 = [char] 10097
    # $char_1 = [char] 124
    $cwd = $executionContext.SessionState.Path.CurrentLocation
    # [$env:COMPUTERNAME], [$Env:USERNAME]
    # "PS > " |>
    # "PS¤> "
    # ｠ ﹤ ﹥ ﹡ Ꚛ ꗞ ꗟ ꔻ ꔼ ꔬ ꖝ ꔭ ꔮ ꔜ ꔝ ꔅ ꔆ ꖜ ꖛ ꕼ ꕹ ꗬ ꕺ ꕬ ꕢ ꕔ ꕕ ꗢ ꗣ ꗤ ꗥ ꗨ ꗳ ꗻ ꘃ ꘈ ꘜ ꘠ ꘨ ꘩ ꘪ
    # ꯁ ꯊ ꯌ ꯕ ꯖ ꯗ ꯘ ꯙ ꯱ ꯲ ꯳ ꯴ ꯵ ꯷ ㉤ ㉥ ㉦ ㉧ ㉨ ㉩ ㆍ ㆎ ㆆ 〇 Ⲑ Ⲫ Ⲋ Ⲱ ⯎ ⯏ ⫷ ⫸ ⪧ ⩥ ⨵ ⨳ ⨠ ⧁ ⦾ ⦿ ⦔ ⧂
    # ⧃ ⥤ ⟢ ⟡ ➽ ➔ ❱ ⌾ ⊙ ⊚ ⊛ ∬ ൏ ಌ ಅ ఴ ᐅ 〉 ⋮ ≻ ▶ ◣ ◤
    # "$($conda_prompt)$($colors_table.col_Green)$($cwd) $($git_prompt)`n$($ENV:_PROMPT_PRIVILEGE)$($colors_table.col_Yellow)PS $($colors_table.col_def)$($dynamic_color_char) "
    # "$($conda_prompt)$($colors_table.col_Green)$($cwd)$($colors_table.col_def) $($git_prompt)`n$($ENV:_PROMPT_PRIVILEGE)$($colors_table.col_Yellow)$char_0$($colors_table.col_def)$char_1 "
    $nested_prompt = "$char_1" * ($nestedPromptLevel + 1)
    "$($conda_prompt)$($colors_table.col_Green)$($cwd)$($colors_table.col_def) $($git_prompt)`n$($ENV:_PROMPT_PRIVILEGE)$($colors_table.col_Yellow)$char_0$($colors_table.col_def)$nested_prompt "
}


#################
### SHORTCUTS ###
#################

$code = 'D:\code'
$horoview = "$code\projects\01_horoview"
$dump = "$code\personal_dump"

$_powershell_dir = $custom_profile | Split-Path -Parent | Split-Path -Parent
$_ps_buffer = "$_powershell_dir\profile\ps_buffer.txt"


###############
### ALIASES ###
###############

### conda / python shortcuts
function conda_activate {
    param($VEnv='workenv') # default to "workenv" instead of "base"
    conda activate $VEnv
}
New-Item -Path Alias:cda -Value conda_activate -Force > $null
function Conda-Deactivate {conda deactivate}
New-Item -Path Alias:cdd -Value Conda-Deactivate -Force > $null
function Conda-Update {conda update conda -n base -c defaults}
New-Item -Path Alias:cdu -Value Conda-Update -Force > $null
function Alias-Python {
    $fake_pythons_path = 'C:\Users\Arthur\AppData\Local\Microsoft\WindowsApps\python*.exe'
    if (Test-Path $fake_pythons_path) {
        Write-Error 'Found fake python executables'
        Remove-Item -Confirm -Path $fake_pythons_path
    }
    try {python.exe $args}
    catch {Write-Error "python.exe not found, activating workenv"; cda; python.exe $args}
}
New-Item -Path Alias:python -Value Alias-Python -Force > $null

### git shortcuts
function Git-Tree {git log --graph --decorate --pretty=oneline --abbrev-commit}
New-Item -Path Alias:git_tree -Value Git-Tree -Force > $null
function Git-Pull-Submodules {git submodules update --init --recursive}
New-Item -Path Alias:git_ps -Value Git-Pull-Submodules -Force > $null
function Git-Update-Submodules {git submodules update --init --recursive --remote}
New-Item -Path Alias:git_us -Value Git-Update-Submodules -Force > $null
function Git-Fetch-Status {git fetch; git status}
New-Item -Path Alias:gfs -Value Git-Fetch-Status -Force > $null

### shell stuff
# edit this script in VSCode
function Edit-Profile {code $profile}
New-Item -Path Alias:ep -Value Edit-Profile -Force > $null
# New-Item -Path Alias:del -Value rm_alias -Force > $null
New-Item -Path Alias:read -Value Get-Content -Force > $null
function la {dir -Force} # group-object, format-table
# la | Format-Table Length, Name
# add a "lr" alias with get-childitem
function Find-Item {Get-ChildItem -Recurse -Filter $args[0]}
New-Item -Path Alias:find -Value Find-Item -Force > $null
# function Touch {python "D:\code\personal_dump\code\python\touch.py" $args}
function Touch-File {
    param([string]$FilePath)
    Out-File -FilePath $FilePath -Append
}
New-Item -Path Alias:touch -Value Touch-File -Force > $null
function Get-Path {"${Env:path}".Split(';')}
New-Item -Path Alias:path -Value Get-Path -Force > $null
New-Item -Path Alias:gj -Value Get-Job -Force > $null
function Clear-Job {Get-Job | ? {$_.State -ne "Running"} | Remove-Job}
New-Item -Path Alias:cj -Value Clear-Job -Force > $null
function Stop-ProcessTree {
    Param([int]$parent_id)
    # ? = Where-Object | % = ForEach-Object
    Get-Process | ? { $_.Parent.Id -eq $parent_id } | % { Stop-ProcessTree $_.Id }
    Stop-Process -Id $parent_id -ErrorAction "SilentlyContinue" -Verbose
    if (!$?) {Write-Output $Error[0].ToString()}
    # Stop-Process -Id $parent_id -WhatIf
}

### Windows specific stuff
New-Item -Path Alias:np -Value notepad -Force > $null
function Make-SymLink {
    param(
        [Parameter(Mandatory = $true)]$TargetPath, # what the link points to
        [Parameter(Mandatory = $true)]$LinkPath # where the link will be
    )
    # check if the target exists
    if (-not $(Test-Path $TargetPath)) {Write-Error "$TargetPath does not exist"; return}
    New-Item -ItemType 'SymbolicLink' -Path $LinkPath -Target (Get-Item $TargetPath).ResolvedTarget
}
New-Item -Path Alias:mklink -Value Make-SymLink -Force > $null
function Open-Ise {
    # opens a file in PowerShell ISE
}
New-Item -Path Alias:ise -Value Open-Ise -Force > $null
function Windows-Terminal { # allows opening a windows terminal as admin with no confirmation
    $as_admin = $False
    foreach ($arg in $args) {if ($arg -match '^(--as-admin|-a)$') {$as_admin = $True}}
    # $wt_args = $args | ? {($_ -ne '--as-admin') -and ($_ -ne '-a')}
    if ($as_admin) {ii "$HOME\Desktop\wt_asadmin.lnk"}
    else {wt.exe $args}
}
New-Item -Path Alias:wt -Value Windows-Terminal -Force > $null

### powershell stuff
function Get-Type {foreach($arg in $args) {$arg.GetType().FullName}}
New-Item -Path Alias:type -Value Get-Type -Force > $Null
function Text-Colors-Test { # tests the string colors of the terminal
    param([string[]]$color_names=("Black","Red","Green","Yellow","Blue","Magenta","Cyan","White"))
    foreach ($color_name in $color_names) {
        $reg_col = $colors_table["col_$color_name"]
        $bri_col = $colors_table["bcol_$color_name"]
        "$($reg_col)This is a sentence colored with regular $color_name"
        "$($bri_col)This is a sentence colored with bright $color_name"
    }
}
New-Item -Path Alias:color_test -Value Text-Colors-Test -Force > $Null


###############
### MODULES ###
###############

# user confirmation functions
. "$_powershell_dir\utils\Confirm.ps1"
# jupyter lab wrapper
. "$_powershell_dir\utils\jupyter_server_wrapper.ps1"
# Recycle bin
. "$_powershell_dir\utils\Recycle.ps1"
# Sudo
. "$_powershell_dir\utils\Sudo.ps1"


$tock = Get-Date
$load_time = ($tock - $tick).TotalMilliseconds
# [math]::Round(($tock - $tick).TotalSeconds), 3)
Write-Information "Profile load time: $([int][math]::Round($load_time))ms"
if (!$Silent) {$InformationPreference = $InformationPreference_backup}
if ($Verbose) {$VerbosePreference = $VerbosePreference_backup}


############
### DUMP ###
############

<#
# show prompt code:
Write-Host (Get-Command prompt).ScriptBlock

function touch {
    if ($($args.count) -eq 0) {
        python "D:\code\personal_dump\code\python\touch.py"
    }
    else {
        for ( $i = 0; $i -lt $args.count; $i++ ) {
            python "C:\Users\Arthur\Documents\scripts\touch.py" "$($args[$i])"
        }
    }
}

function f_test {
    echo $args
    for ( $i = 0; $i -lt $args.count; $i++ ) {
        # echo args[$i]
        echo "$($args[$i])"
    }
    # echo "$($args[$i])"
}
function f_test_2 {
    Param(
        [switch]$myswitch,
        [int]$number
    )
    if ($myswitch) { Write-Output "Switch on" }
    else { Write-Output "Switch off" }
    # Write-Host "update loaded"
    # Write-Output "$HOME"
    Write-Output $number # defaults to 0
    Write-Output "lol"
    Write-Output $args[2]
}

function is_var_assigned {
    Param($var)
    return (!!$var)
}

If (Test-Path "$home\anaconda3\Scripts\conda.exe") {
    $Env:_is_conda_set_up = $False
    function conda_set_up {
        # Write-host "is conda not set up: $Env:_is_conda_set_up"
        if ($Env:_is_conda_set_up -eq $False) {
            # $f_tick = Get-Date
            Write-Host 'Setting up conda ...'
            # (& "$($home)\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
            # $test_output = & "$($home)\anaconda3\Scripts\conda.exe" shell.powershell hook # | ?{$_} | iex
            # conda env
            $Env:_CONDA_ROOT = "$home/anaconda3"
            $Env:CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
            # $Env:_CE_M = ""
            # $Env:_CE_CONDA = ""
            $Env:_CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
            # conda hook (adds conda to path)
            # & "$($home)\anaconda3\Scripts\conda.exe" shell.powershell hook | ?{$_} | iex
            # & "$($Env:_CONDA_ROOT)\Scripts\conda.exe" 'shell.powershell' 'hook' > $null
            # conda PS module
            # Import-Module "$($Env:_CONDA_ROOT)\shell\condabin\Conda.psm1" -ArgumentList @{ChangePs1 = $False}
            Import-Module "$dump\code\powershell\Conda.psm1" -ArgumentList @{ChangePs1 = $False} #-Verbose
            # Conda.psm1 overrides "conda" alias by itself
            $Env:_is_conda_set_up = $True
            # $f_tock = Get-Date
            # Write-Host "Conda load time: $([math]::Round($load_time, 3))"
        }
    }
    function Alias-Conda-Profile {
        # Write-Host 'Alias-Conda-Profile called'
        conda_set_up
        conda $args
    }
    New-Item -Path Alias:conda -Value Alias-Conda-Profile -Force > $null
}
#>

# ".": dot sourcing => the commands in the script run as though you had typed them at the command prompt
# "&": invocation operator =>
# '& "$profile"' reloads this file

# $link = New-Item -ItemType SymbolicLink -Path .\link -Target .\Notice.txt
# $link | Select-Object LinkType, Target

param([switch]$Silent, [switch]$Verbose)
$tick = Get-Date

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

# Import-Module "D:\Code\personal_dump\code\powershell\Recycle.psm1"
# $confirmPreference = 'High'

# set up output and input console encoding to UTF-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# <#
Write-Verbose 'Setting up conda ...'
$Env:_CONDA_ROOT = "$HOME\anaconda3"
$Env:CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
$Env:_CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList @{ChangePs1 = $False} -Verbose:$False
# conda activate base
#>

# prompt setup
if (-not $color_characters_dict) { # only set up colors once
    Write-Verbose 'Setting up prompt colors...'
    # set up the color variables
    # "ESC" character: [char]27
    function gen_color_char {
        param ([int]$char_number)
        "$([char]27)[$($char_number)m"
    }
    $color_characters_dict = @{} # empty hashtable
    # $col_def = color_char_gen 0
    $color_characters_dict.col_def = gen_color_char 0
    # $color_name_array = "Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White"
    # $($col_Black)  $($col_Red)  $($col_Green)  $($col_Yellow)  $($col_Blue)  $($col_Magenta)  $($col_Cyan)  $($col_White)
    # $($bcol_Black) $($bcol_Red) $($bcol_Green) $($bcol_Yellow) $($bcol_Blue) $($bcol_Magenta) $($bcol_Cyan) $($bcol_White)
    $i = 30
    foreach ($color_name in "Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White") {
        $reg_col_var_name = "col_$color_name"
        $reg_col_var_value = gen_color_char $i
        $color_characters_dict["$reg_col_var_name"] = $reg_col_var_value
        $bri_col_var_name = "bcol_$color_name"
        $bri_col_var_value = gen_color_char $($i + 60)
        $color_characters_dict["$bri_col_var_name"] = $bri_col_var_value
        ++$i
    }
    # delete gen_color_char function
    # Remove-Item -path 'function:\gen_color_char'
    Remove-Variable 'color_name', 'reg_col_var_name', 'reg_col_var_value', 'bri_col_var_name', 'bri_col_var_value', 'i'
}
function Prompt-Git-Branch-Name {
    # look for possible branch name, silence git "not in git repo" error
    $branch = $(& "C:\Program Files\Git\cmd\git.exe" rev-parse --abbrev-ref HEAD 2> $null)
    if ($branch) {
        # we're in a git repo
        if ($branch -eq 'HEAD') {
            # we're in detached HEAD state, so print the SHA
            "($($color_characters_dict.col_Red)$(& "C:\Program Files\Git\cmd\git.exe" rev-parse --short HEAD)$($color_characters_dict.col_def))"
        }
        else {
            # we're on an actual branch, so print it
            "($($color_characters_dict.col_Blue)$($branch)$($color_characters_dict.col_def))"
        }
    }
    # if we're not in a git repo, don't return anything
}
function Alias-CD {
    param([string]$DirPath)
    # fail if DirPath is not a directory
    Set-Location $DirPath
    if ($(Get-Location).drive.provider.name -eq 'FileSystem') {
        # we are in a FileSystem drive, safe to look for git branches
        $Env:_PROMPT_GIT_MODIFIER = $(Prompt-Git-Branch-Name)
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
# save git function
function Alias-GIT {
    & "C:\Program Files\Git\cmd\git.exe" $args
    # udpate $Env:_PROMPT_GIT_MODIFIER
    cd .
}
# override "git" alias with git_alias
New-Item -Path Alias:git -Value Alias-GIT -Force > $null
$principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
$admin_role = [Security.Principal.WindowsBuiltInRole]::Administrator
if ($principal.IsInRole($admin_role)) {$ENV:_PROMPT_PRIVILEGE = "$($color_characters_dict.col_def)[$($color_characters_dict.bcol_Blue)ADMIN$($color_characters_dict.col_def)] "}
else {$ENV:_PROMPT_PRIVILEGE = ''}
Remove-Variable 'principal', 'admin_role'
function Prompt {
    # "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
    ### /!\ CANNOT CALL A FUNCTION IN ANY WAY INSIDE PROMPT /!\ ###
    # if we want to keep the "turn red on error" feature
    # => needs to receive state from Env, like conda
    # check if a conda venv is activated, if so color only the venv name
    if ($Env:CONDA_PROMPT_MODIFIER -match '\(([\w\- ]+)\)')
        {$conda_prompt = "($($color_characters_dict.col_Cyan)$($Matches.1)$($color_characters_dict.col_def))`n"}
    else
        {$conda_prompt = ''}
    $git_prompt = [string] $Env:_PROMPT_GIT_MODIFIER
    # default ("[int][char]'>'" to find the integer): [char]62
    # here: [int][char]'¤' => 164
    # '>' => 62
    # $dynamic_color_char = [char] 12903
    # $char_1 = [char] 12903
    $char_0 = [char] 12295
    # $char_1 = [char] 124
    # $char_2 = [char] 65376
    # $char_2 = [char] 9002
    $char_1 = [char] 10097
    # $char_2 = [char] 124
    $cwd = $executionContext.SessionState.Path.CurrentLocation
    # [$env:COMPUTERNAME], [$Env:USERNAME]
    # "PS > " |>
    # "PS¤> "
    # ｠ ﹤ ﹥ ﹡ Ꚛ ꗞ ꗟ ꔻ ꔼ ꔬ ꖝ ꔭ ꔮ ꔜ ꔝ ꔅ ꔆ ꖜ ꖛ ꕼ ꕹ ꗬ ꕺ ꕬ ꕢ ꕔ ꕕ ꗢ ꗣ ꗤ ꗥ ꗨ ꗳ ꗻ ꘃ ꘈ ꘜ ꘠ ꘨ ꘩ ꘪ
    # ꯁ ꯊ ꯌ ꯕ ꯖ ꯗ ꯘ ꯙ ꯱ ꯲ ꯳ ꯴ ꯵ ꯷ ㉤ ㉥ ㉦ ㉧ ㉨ ㉩ ㆍ ㆎ ㆆ 〇 Ⲑ Ⲫ Ⲋ Ⲱ ⯎ ⯏ ⫷ ⫸ ⪧ ⩥ ⨵ ⨳ ⨠ ⧁ ⦾ ⦿ ⦔ ⧂
    # ⧃ ⥤ ⟢ ⟡ ➽ ➔ ❱ ⌾ ⊙ ⊚ ⊛ ∬ ൏ ಌ ಅ ఴ ᐅ 〉 ⋮ ≻ ▶ ◣ ◤
    # "$($conda_prompt)$($color_characters_dict.col_Green)$($cwd) $($git_prompt)`n$($ENV:_PROMPT_PRIVILEGE)$($color_characters_dict.col_Yellow)PS $($color_characters_dict.col_def)$($dynamic_color_char) "
    # "$($conda_prompt)$($color_characters_dict.col_Green)$($cwd)$($color_characters_dict.col_def) $($git_prompt)`n$($ENV:_PROMPT_PRIVILEGE)$($color_characters_dict.col_Yellow)$char_0$($color_characters_dict.col_def)$char_1 "
    $nested_prompt = "$char_1" * ($nestedPromptLevel + 1)
    "$($conda_prompt)$($color_characters_dict.col_Green)$($cwd)$($color_characters_dict.col_def) $($git_prompt)`n$($ENV:_PROMPT_PRIVILEGE)$($color_characters_dict.col_Yellow)$char_0$($color_characters_dict.col_def)$nested_prompt "
}

# shortcuts to important folders
$code = 'D:\code'
$horoview = "$code\projects\01_horoview"
$dump = "$code\personal_dump"

# edit this script in VSCode
function Edit-Profile {
    # edit $profile, resolve if it is a symlink => actually, VSCode doesn't care about symlinks
    # $profile_path = [string] $profile
    # $profile_item = Get-Item $profile_path
    # if ($profile_item.LinkType -eq 'SymbolicLink') {
    #     $profile_path = Resolve-Path $profile_item.ResolvedTarget
    # }
    code $profile
}
New-Item -Path Alias:ep -Value Edit-Profile -Force > $null

# conda shortcuts
function conda_activate {
    param($VEnv='workenv') # default to "workenv" instead of "base"
    conda activate $VEnv
}
New-Item -Path Alias:cda -Value conda_activate -Force > $null
function Conda-Deactivate {conda deactivate}
New-Item -Path Alias:cdd -Value Conda-Deactivate -Force > $null

# activate workenv when python is not in the path
function Alias-Python {
    try {python.exe $args}
    catch {Write-Error "Python.exe not found, activating workenv"; cda; python.exe $args}
}
New-Item -Path Alias:python -Value Alias-Python -Force > $null

# git shortcuts
function Git-Tree {git log --graph --decorate --pretty=oneline --abbrev-commit}
New-Item -Path Alias:git_tree -Value Git-Tree -Force > $null
function Git-Pull-Submodules {git submodules update --init --recursive}
New-Item -Path Alias:git_ps -Value Git-Pull-Submodules -Force > $null
function Git-Update-Submodules {git submodules update --init --recursive --remote}
New-Item -Path Alias:git_us -Value Git-Update-Submodules -Force > $null
function Git-Fetch-Status {git fetch; git status}
New-Item -Path Alias:gfs -Value Git-Fetch-Status -Force > $null

# New-Item -Path Alias:del -Value rm_alias -Force > $null
New-Item -Path Alias:read -Value Get-Content -Force > $null
function la {dir -Force}
# la | Format-Table Length, Name
function Find {Get-ChildItem -Recurse -Filter $args}
# function Touch {python "D:\code\personal_dump\code\python\touch.py" $args}
function Touch {
    param([string]$FilePath)
    Out-File -FilePath $FilePath -Append
}
# nf (new file) alias => checks if file exists
# notepad alias
# New-Item -Path Alias:np -Value c:\windows\notepad.exe
# maybe with "$null > empty.txt" ?
function Make-Link {
    param(
        [Parameter(Mandatory = $true)]$TargetPath, # what the link points to
        [Parameter(Mandatory = $true)]$LinkPath # where the link will be
    )
    # check if the target exists
    if (-not $(Test-Path $TargetPath)) {Write-Error "$TargetPath does not exist"; return}
    $target_absolute_path = Resolve-Path $TargetPath
    # link to the target's target if it is a SymbolicLink
    # (Get-ChildItem .\ | where {$_.LinkType -eq 'SymbolicLink'}).ResolvedTarget
    $target_item = Get-Item $target_absolute_path
    if ($target_item.LinkType -eq 'SymbolicLink') {
        $target_absolute_path = Resolve-Path $target_item.ResolvedTarget
    }
    New-Item -ItemType 'SymbolicLink' -Path $LinkPath -Target $target_absolute_path
}
New-Item -Path Alias:mklink -Value Make-Link -Force > $null
# add a "lr" alias with get-childitem
function Conda-Update {conda update conda -n base -c defaults}
function Env-Path-Items {"${Env:path}".replace(";", "`n")}
# needs to return each path items as a different string, instead of a single string with line breaks
New-Item -Path Alias:path -Value Env-Path-Items -Force > $null
function Open-Ise {
    # opens a file in PowerShell ISE
}
New-Item -Path Alias:ise -Value Open-Ise -Force > $null
function Windows-Terminal { # allows opening a windows terminal as admin with no confirmation
    # $wt_args = ($args | ? {($_) -or ($_)})
    $as_admin = $False
    foreach ($arg in $args) {if ($arg -match '^(--as-admin|-a)$') {$as_admin = $True}}
    # $wt_args = $args | ? {($_ -ne '--as-admin') -and ($_ -ne '-a')}
    if ($as_admin) {ii "$HOME\Desktop\wt_asadmin.lnk"}
    else {wt.exe $args}
}
New-Item -Path Alias:wt -Value Windows-Terminal -Force > $null
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

$powershell_dir = $custom_profile | Split-Path -Parent | Split-Path -Parent
# user confirmation functions
. "$powershell_dir\utils\Confirm.ps1"
# jupyter lab wrapper
. "$powershell_dir\utils\jupyter_server_wrapper.ps1"
# Recycle bin package
. "$powershell_dir\utils\Recycle.ps1"

###

# write the names of the types of the objects passed
function Get-Type {foreach($arg in $args) {$arg.GetType().FullName}}
New-Item -Path Alias:type -Value Get-Type -Force > $Null
# why doesn't it work as a pipe ? => $lol | % {type $_}

# tests the string colors of the terminal
function Text-Colors-Test {
    param([string[]]$color_names=("Black","Red","Green","Yellow","Blue","Magenta","Cyan","White"))
    foreach ($color_name in $color_names) {
        $reg_col = $color_characters_dict["col_$color_name"]
        $bri_col = $color_characters_dict["bcol_$color_name"]
        "$($reg_col)This is a sentence colored with regular $color_name"
        "$($bri_col)This is a sentence colored with bright $color_name"
    }
}
New-Item -Path Alias:color_test -Value Text-Colors-Test -Force > $Null

###
# preference variables

# $confirmPreference = 'Medium'

###

# Start-Sleep .5
$tock = Get-Date
$load_time = ($tock - $tick).TotalMilliseconds
# [math]::Round(($tock - $tick).TotalSeconds), 3)
Write-Information "Profile load time: $([int][math]::Round($load_time))ms"
if (!$Silent) {$InformationPreference = $InformationPreference_backup}
if ($Verbose) {$VerbosePreference = $VerbosePreference_backup}


###############################################################################################
# tests

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

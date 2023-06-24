Write-Output "loading subprofile (profile.ps1) ..."

# <#
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "D:\Programs\anaconda3\Scripts\conda.exe") {
    (& "D:\Programs\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion
# #>

# prompt setup
Write-Output "setup prompt ..."
conda activate base
# conda venv: "$Env:CONDA_PROMPT_MODIFIER"
# function conda_venv_name {
#     if ($Env:CONDA_PROMPT_MODIFIER) {"$($Env:CONDA_PROMPT_MODIFIER)`n"}
#     # if ($Env:CONDA_PROMPT_MODIFIER) {"$($Env:CONDA_PROMPT_MODIFIER)"}
# }
# some colors
# "ESC" character
if (-not $(Test-Path "Variable:esc")) { # don't create the color variables if they already exist
    $esc = [char]27
    function color_char_gen {
        param ([int]$char_number)
        "$($esc)[$($char_number)m"
    }
    $col_def = color_char_gen 0
    $color_name_array = @()
    $color_name_array += "Black"
    # $($col_Black)
    # $($bcol_Black)
    $color_name_array += "Red"
    # $($col_Red)
    # $($bcol_Red)
    $color_name_array += "Green"
    # $($col_Green)
    # $($bcol_Green)
    $color_name_array += "Yellow"
    # $($col_Yellow)
    # $($bcol_Yellow)
    $color_name_array += "Blue"
    # $($col_Blue)
    # $($bcol_Blue)
    $color_name_array += "Magenta"
    # $($col_Magenta)
    # $($bcol_Magenta)
    $color_name_array += "Cyan"
    # $($col_Cyan)
    # $($bcol_Cyan)
    $color_name_array += "White"
    # $($col_White)
    # $($bcol_White)
    $i = 30
    foreach ($color_name in $color_name_array) {
        $reg_col_var_name = "col_$color_name"
        $reg_col_var_value = color_char_gen $i
        # if (-not $(Test-Path "Variable:$($reg_col_var_name)"))
        #     {New-Variable -Name $reg_col_var_name -Value $reg_col_var_value}
        New-Variable -Name $reg_col_var_name -Value $reg_col_var_value
        $bri_col_var_name = "bcol_$color_name"
        $bri_col_var_value = color_char_gen $($i + 60)
        # if (-not $(Test-Path "Variable:$($bri_col_var_name)"))
        #     {New-Variable -Name $bri_col_var_name -Value $bri_col_var_value}
        New-Variable -Name $bri_col_var_name -Value $bri_col_var_value
        ++$i
    }
}
function git_branch_name {
    # look for possible branch name, silence git "not in git repo" error
    $branch = $(git rev-parse --abbrev-ref HEAD 2> $null)
    if ($branch) {
        # we're in a git repo
        if ($branch -eq 'HEAD') {
            # we're in detached HEAD state, so print the SHA
            # $branch = git rev-parse --short HEAD
            # Write-Host " ($branch)" -ForegroundColor "red"
            # $prompt_str = " ($branch)" -ForegroundColor "red"
            "$($col_Red)($(git rev-parse --short HEAD))"
        }
        else {
            # we're on an actual branch, so print it
            # Write-Host " ($branch)" -ForegroundColor "blue"
            # $prompt_str = " ($branch)" -ForegroundColor "blue"
            "$($bcol_Blue)($($branch))"
        }
    }
    # if we're not in a git repo, don't return anything
}
function cd_alias {
    param([string]$path)
    Set-Location -path $path -passthru > $null
    if ($(Get-Location).drive.provider.name -eq 'FileSystem') {
        # we are in a FileSystem drive, safe to look for git branches
        $Env:git_ps_prompt_str = "$(git_branch_name)"
    }
    else {
        # we are not in a FileSystem drive, clear $Env:git_ps_prompt_str
        $Env:git_ps_prompt_str = $null
    }
    # put the git prompt in $Env
    # $Env:git_ps_prompt_str = git_branch_name
}
# override "cd" alias with cd_alias
New-Item -Path Alias:cd -Value cd_alias -Force > $null
function git_alias {
    $str_args = ""
    foreach ($item in $args) {$str_args += [string]$item}
    $str_args
    # $list_args = @("1","2","3","4","5")
    # $result_str = ""
    # foreach ($item in $list_args) {$result_str += $item}
    # return $result_str
}
# override "git" alias with git_alias
# New-Item -Path Alias:git -Value git_alias -Force > $null
# <#
function prompt {
    ### /!\ CANNOT CALL A FUNCTION IN ANY WAY INSIDE PROMPT /!\ ###
    # if we want to keep the "turn red on error" feature
    # => needs to receive state from Env, like conda
    # $venv_name = $(conda_venv_name)
    # $conda_prompt = "$Env:CONDA_PROMPT_MODIFIER"
    if ($Env:CONDA_PROMPT_MODIFIER) {$conda_prompt = "$($bcol_Cyan)$($Env:CONDA_PROMPT_MODIFIER)`n"}
    # $branch_name = $(git_branch_name)
    $git_prompt = "$($Env:git_ps_prompt_str)"
    # default ("[int][char]'>'" to find the integer): [char]62
    # here: [int][char]'¤' => 164
    $dynamic_color_char = [char]164
    $cwd = $executionContext.SessionState.Path.CurrentLocation
    # [$env:COMPUTERNAME]
    # return "`nPS > "
    # return "`nPS & "
    # return "$($conda_prompt)`n$($cwd) PS $($dynamic_color_char) "
    # $nest_level = "$('>' * ($nestedPromptLevel + 1)) "
    # (workenv)
    # D:\code\personal_dump\code\powershell (main)
    # PS>
    # "$($conda_prompt)$($cwd) $($git_prompt)`nPS $($dynamic_color_char) "
    "$($conda_prompt)$($bcol_Green)$($cwd) $($git_prompt)`n$($col_Yellow)PS $($col_def)$($dynamic_color_char) "
}
# add an "admin" flag when running as admin ? add user name ?
# #>
<#
function prompt {
    $nest_level = "$('>' * ($nestedPromptLevel + 1)) "
    # "$(conda_venv_name)$($executionContext.SessionState.Path.CurrentLocation)$(git_branch_name)`nPS>"
    "$(conda_venv_name)$($(Get-Location))$(git_branch_name) PS $nest_level "
    # Get-Location ?
}
#>

function cda {conda activate workenv}
function cdd {conda deactivate}

function jupyter_lab {cda; cd "${code}"; jupyter lab}

# alias git_tree='git log --graph --decorate --pretty=oneline --abbrev-commit'
function git_tree {git log --graph --decorate --pretty=oneline --abbrev-commit}
function git_ps {git submodules update --init --recursive}
function git_us {git submodules update --init --recursive --remote}
function gfs {git fetch; git status}

function rmd {
    param([switch]$f, [switch]$force)
    if ($f -or $force) {Remove-Item $args -r -force}
    else {Remove-Item $args -r}
}
function la {dir -Force}
function find {Get-ChildItem -Recurse -Filter $args}
function touch {python "D:\code\personal_dump\code\python\touch.py" $args}
# notepad alias
# New-Item -Path Alias:np -Value c:\windows\notepad.exe
# touch function with New-Item ?
# maybe with "$null > empty.txt" ?
# function mklink {
#     Param(
#         ...
#     )
# }

function print_path {echo "${Env:path}".replace(";", "`n")}

$code = "D:\Code\"
$horoview = "${code}\projects\01_horoview\"

# <#
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "D:\Programs\anaconda3\Scripts\conda.exe") {
    (& "D:\Programs\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion
# #>



# Write-Host (Get-Command prompt).ScriptBlock
###############################################################################################
# tests

<#
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
#>

# ".": dot sourcing => the commands in the script run as though you had typed them at the command prompt
# "&": invocation operator =>
# '& "$profile"' reloads this file

# $link = New-Item -ItemType SymbolicLink -Path .\link -Target .\Notice.txt
# $link | Select-Object LinkType, Target

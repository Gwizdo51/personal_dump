Write-Host "loading `$profile ($profile) ..."

# Write-Host (Get-Command Prompt).ScriptBlock

<#
function Write-BranchName {
    if ($branch -eq "HEAD") {
        # we're probably in detached HEAD state, so print the SHA
        $branch = git rev-parse --short HEAD
        Write-Host " ($branch)" -ForegroundColor "red"
        # $prompt_str = " ($branch)" -ForegroundColor "red"
    }
    else {
        # we're on an actual branch, so print it
        Write-Host " ($branch)" -ForegroundColor "blue"
        # $prompt_str = " ($branch)" -ForegroundColor "blue"
        # Write-Host " ($branch)" -ForegroundColor "blue"
    }
}


function prompt {
    $base = "PS "
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$('>' * ($nestedPromptLevel + 1)) "

    Write-Host "`n$base" -NoNewline

    $branch = git rev-parse --abbrev-ref HEAD
    if (!!$branch) {
        Write-Host $path -NoNewline -ForegroundColor "green"
        Write-BranchName
    }
    else {
        # no branch
        Write-Host $path -ForegroundColor "green"
    }

    return $userPrompt
}
#>

# so that my conda env display doesn't disappear on profile reload
# function is_conda_set {
#     return (!!$Env:CONDA_EXE)
# }
# $is_conda_set = (!!$Env:CONDA_EXE)
# Write-Output("$is_conda_set")

<#
function conda_prompt {
    # Write-Output "$HOME"
    if (-Not $is_conda_set) {
        Write-Output("conda not set")
        & "$HOME\anaconda3\shell\condabin\conda-hook.ps1"
        conda activate base
    }
    else {Write-Output("conda already set")}
}
#>
# function conda_prompt {
#     . "$HOME\anaconda3\shell\condabin\conda-hook.ps1"
#     conda activate base
# }
# conda_prompt

# setup conda (conda-hook.ps1):
# function conda_hook {
#     $Env:CONDA_EXE = "C:/Users/Arthur/anaconda3\Scripts\conda.exe"
#     $Env:_CE_M = ""
#     $Env:_CE_CONDA = ""
#     $Env:_CONDA_ROOT = "C:/Users/Arthur/anaconda3"
#     # prevent conda from modifying prompt
#     $CondaModuleArgs = @{ChangePs1 = $false}
#     Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs
#     Remove-Variable CondaModuleArgs
# }
# conda_hook

# conda activate base

# custom profile
. "D:\Code\personal_dump\code\powershell\windows_custom_profile.ps1"

# test prompt
<#
function prompt {
#   $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
#   $principal = [Security.Principal.WindowsPrincipal] $identity
#   $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

#   $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
#     elseif($principal.IsInRole($adminRole)) { "[ADMIN]: " }
#     else { '' }
#   ) + 'PS ' + $(Get-Location) +
#     $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
# @"
# (not base)
return "PS lol $($executionContext.SessionState.Path.CurrentLocation) $('>' * ($nestedPromptLevel + 1))"
# "@
}
#>


<#
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
# touch function with New-Item ?
# function mklink {
#     Param(
#         ...
#     )
# }

function print_path {echo "${Env:path}".replace(";", "`n")}

$code = "D:\Code\"
$horoview = "${code}\projects\01_horoview\"


###############################################################################################
# tests

# function touch {
#     if ($($args.count) -eq 0) {
#         python "D:\code\personal_dump\code\python\touch.py"
#     }
#     else {
#         for ( $i = 0; $i -lt $args.count; $i++ ) {
#             python "C:\Users\Arthur\Documents\scripts\touch.py" "$($args[$i])"
#         }
#     }
# }

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
Write-Output "lul"

function is_var_assigned {
    Param($var)
    return (!!$var)
}

# ".": dot sourcing => the commands in the script run as though you had typed them at the command prompt
# "&": invocation operator =>
# '& "$profile"' reloads this file

# $link = New-Item -ItemType SymbolicLink -Path .\link -Target .\Notice.txt
# $link | Select-Object LinkType, Target
#>

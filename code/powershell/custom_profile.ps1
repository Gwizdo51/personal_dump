Write-Host "Loading profile (custom_profile.ps1) ..."
# Write-Host "$($home)"
# Import-Module "D:\Code\personal_dump\code\powershell\Recycle.psm1"

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "$($home)\anaconda3\Scripts\conda.exe") {
    (& "$($home)\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

# prompt setup
# Write-Output "setup prompt ..."
# conda activate base
# conda venv: "$Env:CONDA_PROMPT_MODIFIER"
# function conda_venv_name {
#     if ($Env:CONDA_PROMPT_MODIFIER) {"$($Env:CONDA_PROMPT_MODIFIER)`n"}
#     # if ($Env:CONDA_PROMPT_MODIFIER) {"$($Env:CONDA_PROMPT_MODIFIER)"}
# }
# some colors
if (-not $(Test-Path "Variable:esc")) {
    # set up the color variables
    # "ESC" character
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
        New-Variable -Name $reg_col_var_name -Value $reg_col_var_value
        $bri_col_var_name = "bcol_$color_name"
        $bri_col_var_value = color_char_gen $($i + 60)
        New-Variable -Name $bri_col_var_name -Value $bri_col_var_value
        ++$i
    }
}
function git_branch_name {
    # look for possible branch name, silence git "not in git repo" error
    $branch = $(& "C:\Program Files\Git\cmd\git.exe" rev-parse --abbrev-ref HEAD 2> $null)
    if ($branch) {
        # we're in a git repo
        if ($branch -eq 'HEAD') {
            # we're in detached HEAD state, so print the SHA
            # $branch = git rev-parse --short HEAD
            # Write-Host " ($branch)" -ForegroundColor "red"
            # $prompt_str = " ($branch)" -ForegroundColor "red"
            "$($col_Red)($(& "C:\Program Files\Git\cmd\git.exe" rev-parse --short HEAD))"
        }
        else {
            # we're on an actual branch, so print it
            # Write-Host " ($branch)" -ForegroundColor "blue"
            # $prompt_str = " ($branch)" -ForegroundColor "blue"
            "$($bcol_Blue)($($branch))"
        }
    }
    # if we're not in a git repo, don't return anything
    # needs a unix-style flags parsing
}
function cd_alias {
    param([string]$path)
    Set-Location -path $path -passthru > $null
    if ($(Get-Location).drive.provider.name -eq 'FileSystem') {
        # we are in a FileSystem drive, safe to look for git branches
        $Env:git_ps_prompt_str = $(git_branch_name)
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
# save git function
# New-Item -Path Alias:git_backup -Value git # -Force > $null
function git_alias {
    # Write-Host 'Calling git with args:' $args
    . "C:\Program Files\Git\cmd\git.exe" $args
    # Write-Host 'Success'
    # udpate the prompt branch name
    cd .
}
# override "git" alias with git_alias
New-Item -Path Alias:git -Value git_alias -Force > $null
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
    $dynamic_color_char = [char]62
    $cwd = $executionContext.SessionState.Path.CurrentLocation
    # if (Test-Path Variable:/PSDebugContext) { '[DBG]: ' }
    # elseif($principal.IsInRole($adminRole)) { "[ADMIN]: " }
    # else { '' }
    # [$env:COMPUTERNAME]
    # return "`nPS > "
    # return "`nPS & "
    # return "$($conda_prompt)`n$($cwd) PS $($dynamic_color_char) "
    # $nest_level = "$('>' * ($nestedPromptLevel + 1)) "
    # (workenv)
    # D:\code\personal_dump\code\powershell (main)
    # PS>
    # "$($conda_prompt)$($cwd) $($git_prompt)`nPS $($dynamic_color_char) "
    "$($conda_prompt)$($bcol_Green)$($cwd) $($git_prompt)`n$($col_Yellow)PS$($col_def)$($dynamic_color_char) "
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

# function rmd {
#     param([switch]$f, [switch]$force)
#     if ($f -or $force) {Remove-Item $args -r -force}
#     else {Remove-Item $args -r}
# }
function Move-To-Trashcan { # move items to trash on "rm" calls
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline=$true)] # check pipeline
        [SupportsWildcards()] # check wildcards (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-7.3)
        [string]$Path
    )
    # Write-Host $Path
    # get the absolute path of the item + check if item exists
    $path_is_valid = Test-Path $Path
    if (-not $path_is_valid) {Write-Error 'Path does not exist'; return}
    $Path = Resolve-Path $Path
    # $Path
    # Write-Host $path
    # Write-Host $path_drive_name
    # if $Path is a drive, fail here
    # <#
    $drives_names = $(Get-PSDrive).Name
    $drives_names_cleaned = @()
    foreach ($drive_name in $drives_names) {
            $drives_names_cleaned += $($drive_name + ':\')
            $drives_names_cleaned += $($drive_name + ':')
        }
    # $drives_names_cleaned
    # Write-Host $($drives_names_cleaned -contains $Path)
    if ($drives_names_cleaned -contains $Path)
        {Write-Error 'Cannot remove a drive'; return}
    # $drives_names_cleaned
    # #>
    # if ($Path -eq $($path_drive_name))
    # if ($drives_names_cleaned -contains )
    #     {Write-Error "Cannot remove a drive"; return}
    $parent_dir_path = Split-Path $Path -Parent
    $path_item_name = Split-Path $Path -Leaf
    # Write-Host $parent_dir_path
    # Write-Host $path_item_name
    $shell = New-Object -ComObject 'Shell.Application'
    $shell_dir = $shell.Namespace($parent_dir_path)
    $shell_item = $shell_dir.ParseName($path_item_name)
    # $shell_item | Get-Member
    if ($shell_item.IsFolder) {
        $original_user_message = "Confirm deleting folder '$Path'"
        $user_message = $original_user_message
        while (-not $(Test-Path 'Variable:\confirmed')) {
            # ask for confirmation if trying to remove a directory
            $user_input = [string] $(Read-Host $user_message)
            # default to yes
            if (!$user_input) {$user_input = 'y'}
            # use RegEx here
            switch ($user_input) {
                'y' {$confirmed = $True}
                'Y' {$confirmed = $True}
                'n' {$confirmed = $False}
                'N' {$confirmed = $False}
                default {}
            }
            if (-not $(Test-Path 'Variable:\confirmed')) {
                $user_message = "Did not understand.`n$original_user_message"
            }
        }
        if (-not $confirmed) {Write-Error 'Abort'; return}
        # Write-Host 'removing folder...'
    }
    # return
    $shell_item.InvokeVerb('delete')
    # check success
    $path_exists = Test-Path $Path
    if ($path_exists) {Write-Error 'Some items were not removed'}
    else {Write-Host "Moved '$($col_Red)$($Path)$($col_def)' to trashcan"}
}
New-Item -Path Alias:rm -Value Move-To-Trashcan -Force > $null
# New-Item -Path Alias:del -Value rm_alias -Force > $null
function la {dir -Force}
# la | Format-Table Length, Name
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
# add a "lr" alias with get-childitem
function conda_update {conda update conda -n base -c defaults}

function print_path {echo "${Env:path}".replace(";", "`n")}

$code = "D:\Code\"
$horoview = "${code}\projects\01_horoview\"
$dump = "${code}\personal_dump\"

# <#
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "D:\Programs\anaconda3\Scripts\conda.exe") {
    (& "D:\Programs\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion
# #>


# show prompt code:
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

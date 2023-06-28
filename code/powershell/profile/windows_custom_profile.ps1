Write-Host "Loading personal profile (custom_profile.ps1) ..."
# Import-Module "D:\Code\personal_dump\code\powershell\Recycle.psm1"

# conda module
# => only load conda if conda is needed => "conda activate <venv>" loads conda?
If (Test-Path "$home\anaconda3\Scripts\conda.exe") {
    # (& "$($home)\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
    # $test_output = & "$($home)\anaconda3\Scripts\conda.exe" shell.powershell hook # | ?{$_} | iex
    # conda env
    $Env:_CONDA_ROOT = "$home/anaconda3"
    $Env:CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
    $Env:_CE_M = ""
    $Env:_CE_CONDA = ""
    $Env:_CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
    # conda hook (adds conda to path)
    & "$($Env:_CONDA_ROOT)\Scripts\conda.exe" 'shell.powershell' 'hook' > $null
    # conda PS module
    Import-Module "$($Env:_CONDA_ROOT)\shell\condabin\Conda.psm1"
    # conda activate base
}

# prompt setup
# Write-Output "setup prompt ..."
# some colors
if (-not $(Test-Path "Function:color_char_gen")) { # don't
    Write-Host 'Setting up color variables ...'
    # set up the color variables
    # "ESC" character: [char]27
    function color_char_gen {
        param ([int]$char_number)
        "$([char]27)[$($char_number)m"
    }
    $col_def = color_char_gen 0
    $color_name_array = "Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White"
    # $($col_Black)  $($col_Red)  $($col_Green)  $($col_Yellow)  $($col_Blue)  $($col_Magenta)  $($col_Cyan)  $($col_White)
    # $($bcol_Black) $($bcol_Red) $($bcol_Green) $($bcol_Yellow) $($bcol_Blue) $($bcol_Magenta) $($bcol_Cyan) $($bcol_White)
    $i = 30
    foreach ($color_name in $color_name_array) {
        $reg_col_var_name = "col_$color_name"
        $reg_col_var_value = color_char_gen $i
        New-Variable -Name $reg_col_var_name -Value $reg_col_var_value
        $bri_col_var_name = "bcol_$color_name"
        $bri_col_var_value = color_char_gen $($i + 60)
        New-Variable -Name $bri_col_var_name -Value $bri_col_var_value
        ++$i
    } # put colors in hashtable instead ?
}
function git_branch_name {
    # look for possible branch name, silence git "not in git repo" error
    $branch = $(& "C:\Program Files\Git\cmd\git.exe" rev-parse --abbrev-ref HEAD 2> $null)
    if ($branch) {
        # we're in a git repo
        if ($branch -eq 'HEAD') {
            # we're in detached HEAD state, so print the SHA
            "$($col_Red)($(& "C:\Program Files\Git\cmd\git.exe" rev-parse --short HEAD))"
        }
        else {
            # we're on an actual branch, so print it
            "$($bcol_Blue)($($branch))"
        }
    }
    # if we're not in a git repo, don't return anything
}
function cd-Alias {
    param([string]$path)
    Set-Location $path
    # try {Set-Location $path}
    # catch {Write-Host 'didnt work'}
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
New-Item -Path Alias:cd -Value cd-Alias -Force > $null
# save git function
function git-Alias {
    & "C:\Program Files\Git\cmd\git.exe" $args
    # udpate $Env:git_ps_prompt_str
    cd-Alias .
}
# override "git" alias with git_alias
New-Item -Path Alias:git -Value git-Alias -Force > $null
# $current_windows_identity = [Security.Principal.WindowsIdentity]::GetCurrent()
# $principal = [Security.Principal.WindowsPrincipal] $current_windows_identity
$principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
$admin_role = [Security.Principal.WindowsBuiltInRole]::Administrator
if ($principal.IsInRole($admin_role)) {$privilege = "[$($bcol_Blue)ADMIN$($col_def)] "}
else {$privilege = ''}
# <#
function Prompt {
    ### /!\ CANNOT CALL A FUNCTION IN ANY WAY INSIDE PROMPT /!\ ###
    # if we want to keep the "turn red on error" feature
    # => needs to receive state from Env, like conda
    # check if a conda venv is activated, if so color only the venv name
    if ($Env:CONDA_PROMPT_MODIFIER -match '\(([\w\- ]+)\)')
        {$conda_prompt = "($($bcol_Cyan)$($Matches.1)$($col_def))`n"}
    else
        {$conda_prompt = ''}
    $git_prompt = [string] $Env:git_ps_prompt_str
    # default ("[int][char]'>'" to find the integer): [char]62
    # here: [int][char]'¤' => 164
    $dynamic_color_char = [char] 62
    $cwd = $executionContext.SessionState.Path.CurrentLocation
    # [$env:COMPUTERNAME], [$Env:USERNAME]
    # return "`nPS > "
    # return "`nPS & "
    "$($conda_prompt)$($bcol_Green)$($cwd) $($git_prompt)`n$($col_def)$($privilege)$($col_Yellow)PS $($col_def)$($dynamic_color_char) "
    # add nested prompts ?
    # change path color to regular green ?
}
# >

# edit this script in VSCode
# function Edit-Profile {}
# New-Item -Path Alias:ep -Value Edit-Profile -Force > $null

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
function Recycle { # move items to trash on "rm" calls
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline=$true)] # check pipeline
        [SupportsWildcards()] # check wildcards (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-7.3)
        [string[]]$Path # should be able to take a list of paths
    )
    # Write-Host $Path
    # get the absolute path of the item + check if item exists
    # try - catch here
    $path_is_valid = Test-Path $Path
    if (-not $path_is_valid) {Write-Error "$Path does not exist"; return $null}
    $Path = Resolve-Path $Path
    # if $Path is a drive, fail here
    # /!\ "D:" != "D:/" /!\
    # => the drives remember the state in which you left them
    # so "<drive>:" refers to the last container the drive visited (root if never visited this session)
    # and "<drive>:/" refers to the drive's root container
    # check if the drive provider is a FileSystem
    # $drives_names = $(Get-PSDrive).Name
    # return $drives_names
    # $drives_names_cleaned = @()
    # foreach ($drive_name in $drives_names) {
    #     $drives_names_cleaned += $($drive_name + ':\')
    #     # $drives_names_cleaned += $($drive_name + ':')
    # }
    # $drives_names_cleaned
    # Write-Host $($drives_names_cleaned -contains $Path)
    $current_drive = $(Get-Location).Drive
    if (-not $($current_drive.Provider.Name -eq 'FileSystem'))
        {Write-Error 'Can only recycle files, folders and links'; return $null}
    if ($Path -eq $($current_drive.Name + ':\'))
        {Write-Error 'Cannot recycle a drive'; return $null}
    $parent_dir_path = Split-Path $Path -Parent
    $path_item_name = Split-Path $Path -Leaf
    return $parent_dir_path, $path_item_name
    # Write-Host $parent_dir_path
    # Write-Host $path_item_name
    $shell = New-Object -ComObject 'Shell.Application'
    $shell_dir = $shell.Namespace($parent_dir_path)
    $shell_item = $shell_dir.ParseName($path_item_name)
    # $shell_item | Get-Member
    if ($shell_item.IsFolder) {
        $original_user_message = "Confirm deleting folder '$Path' ([y]/n) "
        $user_message = $original_user_message
        while (-not $(Test-Path 'Variable:\confirmed')) {
            # ask for confirmation if trying to remove a directory
            $user_input = [string] $(Read-Host $user_message)
            Write-Host $user_input #> $null
            # default to yes
            if (!$user_input) {$user_input = 'y'}
            # use RegEx here
            $user_input -match '^([yn]|yes|no)$' # does not seem to work super well
            # $(!!$Matches)
            Write-Host $Matches.0

            # $Matches = $null
            # switch ($user_input) {
            #     'y' {$confirmed = $True}
            #     'Y' {$confirmed = $True}
            #     'n' {$confirmed = $False}
            #     'N' {$confirmed = $False}
            #     default {}
            # }
            # if (-not $(Test-Path 'Variable:\confirmed')) {
            # Write-Host $(!$Matches)
            # Write-Host $(!!$Matches)
            if (!$Matches) {
                $user_message = "Did not understand.`n$original_user_message"
            }
            else {
                # $Matches = $nul
                # set $confirmed
                # $user_message = "understood."
                # $confirmed =

            }
        }
        if (-not $confirmed) {Write-Error 'Abort'; return $null}
        # Write-Host 'removing folder...'
    }
    return $null
    $shell_item.InvokeVerb('delete')
    # check success
    $path_exists = Test-Path $Path
    if ($path_exists) {Write-Error 'Some items were not removed'}
    else {Write-Host "Moved '$($col_Red)$($Path)$($col_def)' to trashcan"}
}
New-Item -Path Alias:rm -Value Move-To-Trashcan -Force > $null
# New-Item -Path Alias:del -Value rm_alias -Force > $null
function Open-RecyleBin {start shell:RecycleBinFolder}
function ii-Alias { # to allow opening the recycle bin with "ii" alias
    # use a try catch here
    # Invoke-Item $args
}
# New-Item -Path Alias:ii -Value ii-alias -Force > $null
function la {dir -Force}
# la | Format-Table Length, Name
function Find {Get-ChildItem -Recurse -Filter $args}
function Touch {python "D:\code\personal_dump\code\python\touch.py" $args}
# notepad alias
# New-Item -Path Alias:np -Value c:\windows\notepad.exe
# touch function with New-Item ?
# maybe with "$null > empty.txt" ?
function mklink {
    # New-Item -ItemType SymbolicLink -Path '<link_path>' -Target '<original_item_path>'
    # param()
}
# add a "lr" alias with get-childitem
function Conda-Update {conda update conda -n base -c defaults}
function Env-Path-Items {"${Env:path}".replace(";", "`n")}
# needs to return each path items as a different string, instead of a single string with line breaks
New-Item -Path Alias:path -Value Env-Path-Items -Force > $null
function Open-Ise {
    # opens a file in PowerShell ISE
}
New-Item -Path Alias:ise -Value Open-Ise -Force > $null
function wt-Alias {
    # param([switch])
    # $wt_args = ($args | ? {($_) -or ($_)})
    $as_admin = $False
    foreach ($arg in $args) {
        if ($arg -match '^(--as-admin|-a)$')
            {$as_admin = $True}
    }
    $wt_args = $args | ? {($_ -ne '--as-admin') -and ($_ -ne '-a')}
    if ($as_admin) {ii "$HOME\Desktop\wt_asadmin.lnk"}
    else {wt.exe $wt_args}
}
New-Item -Path Alias:wt -Value wt-Alias -Force > $null

# shortcuts to important folders
$code = 'D:\Code\'
$horoview = "${code}\projects\01_horoview\"
$dump = "${code}\personal_dump\"

###

function Get-Type {
    foreach($arg in $args) {
        Write-Output $arg.GetType().FullName
    }
}
New-Item -Path Alias:type -Value Get-Type -Force > $null



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
#>

# ".": dot sourcing => the commands in the script run as though you had typed them at the command prompt
# "&": invocation operator =>
# '& "$profile"' reloads this file

# $link = New-Item -ItemType SymbolicLink -Path .\link -Target .\Notice.txt
# $link | Select-Object LinkType, Target

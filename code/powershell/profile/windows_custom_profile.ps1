$tick = Get-Date
Write-Host "Loading personal profile (custom_profile.ps1) ..."
# Import-Module "D:\Code\personal_dump\code\powershell\Recycle.psm1"

# conda module
# => only load conda if conda is needed => "conda activate <venv>" loads conda?
<#
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
    Import-Module "D:\code\personal_dump\code\powershell\Conda.psm1" -Verbose
    conda activate base
}
#>

# prompt setup
if (-not $color_characters_dict) { # only set up colors once
    Write-Host 'Setting up prompt colors ...'
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
    Remove-Item -path 'function:\gen_color_char'
    Remove-Variable 'color_name', 'reg_col_var_name', 'reg_col_var_value', 'bri_col_var_name', 'bri_col_var_value', 'i'
}
function Prompt-Git-Branch-Name {
    # look for possible branch name, silence git "not in git repo" error
    $branch = $(& "C:\Program Files\Git\cmd\git.exe" rev-parse --abbrev-ref HEAD 2> $null)
    if ($branch) {
        # we're in a git repo
        if ($branch -eq 'HEAD') {
            # we're in detached HEAD state, so print the SHA
            "$($color_characters_dict.col_Red)($(& "C:\Program Files\Git\cmd\git.exe" rev-parse --short HEAD))"
        }
        else {
            # we're on an actual branch, so print it
            "$($color_characters_dict.bcol_Blue)($($branch))"
        }
    }
    # if we're not in a git repo, don't return anything
}
function Alias-CD {
    param([string]$path)
    Set-Location $path
    # try {Set-Location $path}
    # catch {Write-Host 'didnt work'}
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
if ($principal.IsInRole($admin_role)) {$ENV:_PROMPT_PRIVILEGE = "[$($color_characters_dict.bcol_Blue)ADMIN$($color_characters_dict.col_def)] "}
else {$ENV:_PROMPT_PRIVILEGE = ''}
Remove-Variable 'principal', 'admin_role'
function Prompt {
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
    $dynamic_color_char = [char] 62
    $cwd = $executionContext.SessionState.Path.CurrentLocation
    # [$env:COMPUTERNAME], [$Env:USERNAME]
    # return "`nPS > "
    # return "`nPS & "
    "$($conda_prompt)$($color_characters_dict.col_Green)$($cwd) $($git_prompt)`n$($color_characters_dict.col_def)$($ENV:_PROMPT_PRIVILEGE)$($color_characters_dict.col_Yellow)PS $($color_characters_dict.col_def)$($dynamic_color_char) "
    # add nested prompts ?
}

# shortcuts to important folders
$code = 'D:\code'
$horoview = "$code\projects\01_horoview"
$dump = "$code\personal_dump"

# edit this script in VSCode
function Edit-Profile {
    # edit $profile, resolve if it is a symlink

    # code "$dump\code\powershell\profile\windows_custom_profile.ps1"
    }
New-Item -Path Alias:ep -Value Edit-Profile -Force > $null

# override "conda" cmd to set it up only when it is called for the first time
<#
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
# <# test conda
Write-Host 'Setting up conda ...'
$Env:_CONDA_ROOT = "$HOME\anaconda3"
$Env:CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
$Env:_CONDA_EXE = "$($Env:_CONDA_ROOT)\Scripts\conda.exe"
Import-Module "$dump\code\powershell\FastConda.psm1" -ArgumentList @{ChangePs1 = $False}
conda activate base
#>

# conda shortcuts
function Conda-Activate {
    param($venv='workenv') # default to "workenv" instead of "base"
    conda activate $venv
}
New-Item -Path Alias:cda -Value Conda-Activate -Force > $null
function Conda-Deactivate {conda deactivate}
New-Item -Path Alias:cdd -Value Conda-Deactivate -Force > $null

# jupyter lab on workenv shortcut
function Jupyter-Lab {cda; cd $code; jupyter lab}
New-Item -Path Alias:jupyter_lab -Value Jupyter-Lab -Force > $null

# git shortcuts
function Git-Tree {git log --graph --decorate --pretty=oneline --abbrev-commit}
New-Item -Path Alias:git_tree -Value Git-Tree -Force > $null
function Git-Pull-Submodules {git submodules update --init --recursive}
New-Item -Path Alias:git_ps -Value Git-Pull-Submodules -Force > $null
function Git-Update-Submodules {git submodules update --init --recursive --remote}
New-Item -Path Alias:git_us -Value Git-Update-Submodules -Force > $null
function Git-Fetch-Status {git fetch; git status}
New-Item -Path Alias:gfs -Value Git-Fetch-Status -Force > $null

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
    else {Write-Host "Moved '$($col_Red)$($Path)$($color_characters_dict.col_def)' to trashcan"}
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
function wt-Alias { # allows opening a windows terminal as admin with no confirmation
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

###

# write the names of the types of the objects passed
function Get-Type {foreach($arg in $args) {$arg.GetType().FullName}}
New-Item -Path Alias:type -Value Get-Type -Force > $Null
# why doesn't it work as a pipe ?

# tests the string colors of the terminal
function Text-Colors-Test {

}
New-Item -Path Alias:color_test -Value Text-Colors-Test -Force > $Null

###

# Start-Sleep .5
$tock = Get-Date
$load_time = ($tock - $tick).TotalMilliseconds
# [math]::Round(($tock - $tick).TotalSeconds), 3)
Write-Host "Profile load time: $([int][math]::Round($load_time))ms"


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

param([switch]$Silent, [switch]$Verbose)
$tick = Get-Date

# set output and input shell encoding to UTF-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
# display the messages from the information stream
$InformationPreference = 'Continue'
# set $InformationPreference to 'Continue' for the profile load, unless $Silent is on
if ($Silent) {
    $InformationPreference_backup = $InformationPreference
    $InformationPreference = 'SilentlyContinue'
}
if ($Verbose) {
    $VerbosePreference_backup = $VerbosePreference
    $VerbosePreference = 'Continue'
}

Write-Information "Loading personal profile (windows_custom_profile.ps1)..."


#############
### CONDA ###
#############

if (Test-Path -Path 'Env:_CONDA_ROOT') {
    Write-Verbose 'Setting up Conda ...'
    $Env:CONDA_EXE = "${Env:_CONDA_ROOT}\Scripts\conda.exe"
    $Env:_CONDA_EXE = "${Env:_CONDA_ROOT}\Scripts\conda.exe"
    Import-Module "${Env:_CONDA_ROOT}\shell\condabin\Conda.psm1" -ArgumentList @{ChangePs1 = $False} -Verbose:$False
    # conda activate base
}


##############
### PROMPT ###
##############

Write-Verbose 'Setting up prompt colors ...'
function _gen_colors_hashtable {
    function gen_color_char {
        param ([int] $color_char_number)
        Write-Output "$([char] 27)[${color_char_number}m"
    }
    # empty hashtable:
    $colors_table = @{}
    $colors_table['col_def'] = gen_color_char 0
    # regular colors:
    # $($colors_table.col_Black) $($colors_table.col_Red) $($colors_table.col_Green) $($colors_table.col_Yellow)
    # $($colors_table.col_Blue) $($colors_table.col_Magenta) $($colors_table.col_Cyan) $($colors_table.col_White)
    # bright colors:
    # $($colors_table.bcol_Black) $($colors_table.bcol_Red) $($colors_table.bcol_Green) $($colors_table.bcol_Yellow)
    # $($colors_table.bcol_Blue) $($colors_table.bcol_Magenta) $($colors_table.bcol_Cyan) $($colors_table.bcol_White)
    $i = 30
    foreach ($color_name in 'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White') {
        $reg_col_var_name = "col_${color_name}"
        $reg_col_var_value = gen_color_char $i
        $colors_table["${reg_col_var_name}"] = $reg_col_var_value
        $bri_col_var_name = "bcol_${color_name}"
        $bri_col_var_value = gen_color_char $($i + 60)
        $colors_table["${bri_col_var_name}"] = $bri_col_var_value
        ++$i
    }
    return $colors_table
}
$colors_table = _gen_colors_hashtable

function _gen_git_prompt {
    # look for possible branch name, silence git "not in git repo" error
    $branch = $(& $Env:GIT_EXE 'rev-parse' '--abbrev-ref' 'HEAD' 2> $null)
    if ($branch -eq $null) { # not in a git repo, don't return anything
        return ''
    }
    if ($branch -eq 'HEAD') { # we're in detached HEAD state, so print the SHA
        return "($($colors_table.col_Red)$(& $Env:GIT_EXE 'rev-parse' '--short' 'HEAD')$($colors_table.col_def))"
    }
    else { # we're on an actual branch, so print it
        return "($($colors_table.col_Blue)$($branch)$($colors_table.col_def))"
    }
}

function _gen_privilege_prompt { # add "[ADMIN]" to the prompt if the shell is opened as admin
    $principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    $admin_role = [Security.Principal.WindowsBuiltInRole]::Administrator
    if ($principal.IsInRole($admin_role)) {
        $ENV:_PROMPT_PRIVILEGE = "$($colors_table.col_def)[$($colors_table.bcol_Blue)ADMIN$($colors_table.col_def)] "
    }
}
_gen_privilege_prompt

function Prompt {
    # "PS $($ExecutionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
    ### /!\ CANNOT CALL A FUNCTION IN ANY WAY INSIDE PROMPT /!\ ###
    # if we want to keep the "turn red on error" feature (from PSReadLine)
    # => needs to receive state from "Env" drive, like conda

    # check if a conda venv is activated, if so color only the venv name
    if ($Env:CONDA_PROMPT_MODIFIER -match '\(([\w\- ]+)\)')
        {$conda_prompt = "($($colors_table.col_Cyan)$($Matches.1)$($colors_table.col_def))`n"}
    else
        {$conda_prompt = ''}
    $cwd = $ExecutionContext.SessionState.Path.CurrentLocation

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
    # [$env:COMPUTERNAME], [$Env:USERNAME]
    # "PS > " |>
    # "PS¤> "
    # ｠ ﹤ ﹥ ﹡ Ꚛ ꗞ ꗟ ꔻ ꔼ ꔬ ꖝ ꔭ ꔮ ꔜ ꔝ ꔅ ꔆ ꖜ ꖛ ꕼ ꕹ ꗬ ꕺ ꕬ ꕢ ꕔ ꕕ ꗢ ꗣ ꗤ ꗥ ꗨ ꗳ ꗻ ꘃ ꘈ ꘜ ꘠ ꘨ ꘩ ꘪ
    # ꯁ ꯊ ꯌ ꯕ ꯖ ꯗ ꯘ ꯙ ꯱ ꯲ ꯳ ꯴ ꯵ ꯷ ㉤ ㉥ ㉦ ㉧ ㉨ ㉩ ㆍ ㆎ ㆆ 〇 Ⲑ Ⲫ Ⲋ Ⲱ ⯎ ⯏ ⫷ ⫸ ⪧ ⩥ ⨵ ⨳ ⨠ ⧁ ⦾ ⦿ ⦔ ⧂
    # ⧃ ⥤ ⟢ ⟡ ➽ ➔ ❱ ⌾ ⊙ ⊚ ⊛ ∬ ൏ ಌ ಅ ఴ ᐅ 〉 ⋮ ≻ ▶ ◣ ◤

    $nested_prompt = "${char_1}" * ($nestedPromptLevel + 1)
    "${conda_prompt}$($colors_table.col_Green)${cwd}$($colors_table.col_def) ${Env:_GIT_PROMPT_MODIFIER}`n" + `
        "${ENV:_PROMPT_PRIVILEGE}$($colors_table.col_Yellow)${char_0}$($colors_table.col_def)${nested_prompt} "
}


#################
### SHORTCUTS ###
#################

# $_powershell_dir = $custom_profile | Split-Path -Parent | Split-Path -Parent
$_powershell_dir = "${dump}\code\powershell"
$_ps_buffer = "${_powershell_dir}\profile\ps_buffer.txt"


##############
### DRIVES ###
##############

# registry
New-PSDrive -Name 'HKCR' -PSProvider 'Registry' -Root 'HKEY_CLASSES_ROOT' *> $null
New-PSDrive -Name 'HKU' -PSProvider 'Registry' -Root 'HKEY_USERS' *> $null
New-PSDrive -Name 'HKCC' -PSProvider 'Registry' -Root 'HKEY_CURRENT_CONFIG' *> $null


###############
### ALIASES ###
###############

### conda
function Conda-Activate {
    param($VEnv = $default_conda_venv) # default to $default_conda_venv instead of "base"
    conda activate $VEnv
}
New-Item -Path Alias:cda -Value Conda-Activate -Force > $null
function Conda-Deactivate {conda deactivate}
New-Item -Path Alias:cdd -Value Conda-Deactivate -Force > $null
function Conda-Update {conda update conda -n base -c defaults -y}
New-Item -Path Alias:cdu -Value Conda-Update -Force > $null

### python
function Alias-Python {
    # $fake_python_path = 'C:\Users\Arthur\AppData\Local\Microsoft\WindowsApps\python*.exe'
    $fake_python_path = "${HOME}\AppData\Local\Microsoft\WindowsApps\python.exe"
    if (Test-Path $fake_python_path) {
        Write-Error 'Found fake python executable'
        Remove-Item -Path $fake_python_path -Confirm
    }
    try {& 'python.exe' $args}
    catch {
        Write-Error "python.exe not found"
        $choices_table = @{
            0 = '&Yes', 'Activate the default conda virtual environment to run Python.';
            1 = '&No', 'Exit.'
        }
        $choice = Confirmation-Prompt -Question "Activate ${default_conda_venv}?" -ChoicesTable $choices_table
        if ($choice -eq 0) {
            Conda-Activate
            & 'python.exe' $args
        }
    }
}
New-Item -Path Alias:python -Value Alias-Python -Force > $null

### git
function Alias-GIT {
    # call git
    & $Env:GIT_EXE $args
    # udpate $Env:_GIT_PROMPT_MODIFIER
    Alias-CD -DirPath '.'
}
New-Item -Path Alias:git -Value Alias-GIT -Force > $null
function Git-Tree {git log --graph --decorate --pretty=oneline --abbrev-commit}
New-Item -Path Alias:git_tree -Value Git-Tree -Force > $null
function Git-PullSubmodules {git submodules update --init --recursive}
New-Item -Path Alias:git_ps -Value Git-PullSubmodules -Force > $null
function Git-UpdateSubmodules {git submodules update --init --recursive --remote}
New-Item -Path Alias:git_us -Value Git-UpdateSubmodules -Force > $null
function Git-FetchStatus {git fetch --all; git status}
New-Item -Path Alias:gfs -Value Git-FetchStatus -Force > $null

### shell stuff
# edit the profile file in VSCode
function Edit-Profile {code $PROFILE}
New-Item -Path Alias:ep -Value Edit-Profile -Force > $null
function Alias-CD {
    [CmdletBinding()]
    param([string] $DirPath)
    # set the new current directory
    Set-Location $DirPath -ErrorAction Stop
    # update the git prompt when necessary
    if ($(Get-Location).drive.provider.name -eq 'FileSystem') {
        # we are in a FileSystem drive, safe to look for git branches
        $Env:_GIT_PROMPT_MODIFIER = _gen_git_prompt
    }
    else {
        # we are not in a FileSystem drive, clear $Env:_GIT_PROMPT_MODIFIER
        $Env:_GIT_PROMPT_MODIFIER = ''
    }
}
# override "cd" alias with cd_alias
New-Item -Path Alias:cd -Value Alias-CD -Force > $null
New-Item -Path Alias:read -Value Get-Content -Force > $null
# items listing:
# mode:
# l (link)
# d (directory)
# a (archive)
# r (read-only)
# h (hidden)
# s (system)
function List-Items {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
    param(
        [Parameter(ValueFromPipeline)] [SupportsWildcards()] [string[]] $Path,
        [switch] $Recurse,
        [switch] $NoHidden
    )
    process {
        # $PSCmdlet.ShouldProcess('custom WhatIf message', 'custom Confirm message', '')
        if ($Path.Count -eq 0) {
            $Path += $ExecutionContext.SessionState.Path.CurrentLocation
        }
        foreach ($path_item in $Path) {
            if ($Recurse) {$Recurse_msg = ', recursively'}
            else {$Recurse_msg = ''}
            if ($NoHidden) {$NoHidden_msg = 'visible '}
            else {$NoHidden_msg = ''}
            $whatif_msg = "Listing all ${NoHidden_msg}items in ${path_item}${Recurse_msg}"
            $confirm_msg = "List all ${NoHidden_msg}items in ${path_item}${Recurse_msg}?"
            if ($PSCmdlet.ShouldProcess($whatif_msg, $confirm_msg, '')) {
                Get-ChildItem -Force:$(!$NoHidden) -Recurse:$Recurse -Path $path_item
            }
        }
    }
}
New-Item -Path Alias:l -Value List-Items -Force > $null
New-Item -Path Alias:la -Value List-Items -Force > $null
function List-ItemsRecursive {Invoke-Expression "List-Items -Recurse ${args}"}
New-Item -Path Alias:lr -Value List-ItemsRecursive -Force > $null

function Find-Item {Get-ChildItem -Recurse -Filter $args[0]}
New-Item -Path Alias:find -Value Find-Item -Force > $null
# function Touch {python "D:\code\personal_dump\code\python\touch.py" $args}
function Touch-File {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(ValueFromPipeline)] [string[]] $FilePath,
        [switch] $Force
    )
    process {
        $FilePath | ? {$PSCmdlet.ShouldProcess("Touching ${_}", "Touch ${_}?", '')} | % {
            $ConfirmPreference = 'None'
            Out-File -FilePath $_ -Append -Force:$Force
        }
    }
}
New-Item -Path Alias:touch -Value Touch-File -Force > $null
function Get-Path {Write-Output "${Env:Path}".Split(';')}
New-Item -Path Alias:path -Value Get-Path -Force > $null
New-Item -Path Alias:gj -Value Get-Job -Force > $null
function Clear-Job {Get-Job | ? {$_.State -ne 'Running'} | Remove-Job}
New-Item -Path Alias:cj -Value Clear-Job -Force > $null
function Stop-ProcessTree {
    Param([int] $parent_id)
    # ? = Where-Object | % = ForEach-Object
    Get-Process | ? { $_.Parent.Id -eq $parent_id } | % { Stop-ProcessTree $_.Id }
    Stop-Process -Id $parent_id -ErrorAction 'SilentlyContinue' -Verbose
    if (!$?) {Write-Output $Error[0].ToString()}
    # Stop-Process -Id $parent_id -WhatIf
}
function Get-FullHelp {
    param([string] $function)
    Get-Help -Full $function
}
New-Item -Path Alias:man2 -Value Get-FullHelp -Force > $null

### Windows specific stuff
New-Item -Path Alias:np -Value notepad -Force > $null
function Make-SymLink {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $TargetPath, # what the link points to
        [Parameter(Mandatory)] $LinkPath # where the link will be
    )
    # check if the target exists
    # if (-not $(Test-Path $TargetPath)) {Write-Error "$TargetPath does not exist"}
    if (-not $(Test-Path $TargetPath)) {$PSCmdlet.ThrowTerminatingError("${TargetPath} does not exist")}
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
    if ($as_admin) {ii "${HOME}\Desktop\wt_asadmin.lnk"}
    else {wt.exe $args}
}
New-Item -Path Alias:wt -Value Windows-Terminal -Force > $null
function Update-PS7 {winget upgrade --name powershell}
New-Item -Path Alias:psupdate -Value Update-PS7 -Force > $null
function Update-Git {git update-git-for-windows}
New-Item -Path Alias:git_update -Value Update-Git -Force > $null

### powershell stuff
function Get-Type {foreach($arg in $args) {$arg.GetType().FullName}}
New-Item -Path Alias:type -Value Get-Type -Force > $Null
function Test-TextColors { # tests the string colors of the terminal
    param([string[]] $color_names = ("Black","Red","Green","Yellow","Blue","Magenta","Cyan","White"))
    foreach ($color_name in $color_names) {
        $reg_col = $colors_table["col_$color_name"]
        $bri_col = $colors_table["bcol_$color_name"]
        "${reg_col}This is a sentence colored with regular ${color_name}"
        "${bri_col}This is a sentence colored with bright ${color_name}"
    }
    "$($colors_table.col_def)"
}
New-Item -Path Alias:color_test -Value Test-TextColors -Force > $Null


###############
### MODULES ###
###############

# user confirmation functions
. "${_powershell_dir}\utils\Confirm.ps1"
# jupyter lab wrapper
. "${_powershell_dir}\utils\jupyter_server_wrapper.ps1"
# Recycle bin
. "${_powershell_dir}\utils\Recycle.ps1"
# Sudo
. "${_powershell_dir}\utils\Sudo.ps1"


$tock = Get-Date
$load_time = ($tock - $tick).TotalMilliseconds
# [math]::Round(($tock - $tick).TotalSeconds), 3)
Write-Information "Profile load time: $([int] [math]::Round($load_time))ms"
if ($Silent) {$InformationPreference = $InformationPreference_backup}
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

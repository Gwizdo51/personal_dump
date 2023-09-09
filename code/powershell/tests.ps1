<#
# access types properties and methods: Get-Member - https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-04?view=powershell-7.3

# get the type: https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-04?view=powershell-7.3
Write-Host('types:')
Write-Host("$((10).GetType())")
# value types:
    # null reference (unassignable variable)
    $null = 10; Write-Host(!!$null)
    # [bool], [switch]
    Write-Host("$true $false")
    # [char]
    # "| Out-String" to get full output of GetType
    # Write-Host("$(([char]'f').GetType() | Out-String)")
    Write-Host("$(([char]'f').GetType()) $([char]'f')")
    Write-Host([char]::IsDigit('0'))
    # [int]
    Write-Host("$((5).GetType()) $([int]5)")
    Write-Host([int]::MinValue)
    # [byte]
    Write-Host("$(([byte]36).GetType()) $([byte]36)")
    Write-Host([byte]::MaxValue)
    # [single], [float] (32 bit)
    Write-Host("$(([single]3.6).GetType()) $([single]3.6)")
    Write-Host([single]::NaN)
    # [double] (64 bit)
    Write-Host("$((-17.58).GetType()) $(-17.58)")
    Write-Host([double]::PositiveInfinity)
    # [decimal] (128 bit)
    Write-Host("$(([decimal]132.586).GetType()) $([double]132.586)")
    Write-Host([decimal]::MaxValue)
# reference types:
    # [string]
    Write-Host("$(('abc').GetType()) $('abc')")
    Write-Host("$(('abc').Length)")
    # Write-Host("$(('abc').GetType() | Out-String)")
    # [Array]
    $my_array = 1,2,3; Write-Host($my_array); Write-Host("$($my_array)")
    Write-Host("$(($my_array).GetType()) $($my_array)")
    # Write-Host("$(($my_array).GetType() | Out-String)")
    Write-Host("$(($my_array).GetType())")
    # [Hashtable]
    $my_hastable = @{
        first_name = "John";
        last_name = "Doe";
        id = 123
    }
    Write-Host("$($my_hastable.first_name)")
    Write-Host("$($my_hastable["last_name"])")
    Write-Host("$($my_hastable.Keys)")
    Write-Host("$($my_hastable.Values)")

# get the type:
# Write-Host($true.GetType())
# Write-Host("$($true.GetType() | Out-String)")

# convert types:
[char] "a"
[string] [char] "a"
[bool] 10

# assign value to variable, delete variable:
Write-Host ''
Write-Host 'variables:'
$myvar = 10
# assign same value to multiple variables:
$a = $b = $c = "same stuff"
$a, $b, $c
# does the variable exist
Write-Host $(!!$myvar)
Write-Host $(Test-Path 'Variable:myvar')
# Test-Path
# Remove-Variable
$myvar = $null
# colored print
Write-Host $(!!$myvar) -ForegroundColor "Blue"
# $test = $(Write-Output "colored" -ForegroundColor "Blue")
$test = Write-Host "test" -ForegroundColor "Blue"
Write-Host $(!!$test)
# create new variables by name https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-variable?view=powershell-7.3
New-Variable -Name "by_name" -Value "lol"
Write-Host $(!!$by_name)
Write-Host $by_name
#>
<#
# private items: (don't know what for but oh well)
$a = 2
$private:b = 3
#>
<#
Write-Host ''
Write-Host 'functions:'

# assign function return value to variable:
function add {
    Param([int]$value_1=0, [int]$value_2=0)
    $sum = $value_1 + $value_2
    return $sum
}
$lol = add -value_2 5
$lol2 = $(add 1 (-10))
Write-Host($lol)
Write-Host($lol2)
Write-Host "$(add -value_1 (-4) -value_2 2)"
Write-Host "$(add)"

# assignment test
function is_var_assigned {
    Param($var)
    # Write-Host($var)
    return (!!$var)
}
Write-Host("$(is_var_assigned($null))")
$my_var = 10
Write-Host("$(is_var_assigned($my_var))")

# positional + named parameter
Write-Host ''
Write-Host 'positional + named parameters:'
function pos_named{
    Param([switch]$verbose, [string]$file_name)
    if ($verbose) {Write-Host "verbose on"}
    else {Write-Host "verbose off"}
    Write-Host "$(is_var_assigned $args)"
    Write-Host $args
    Write-Host $file_name
}
# Write-Host ''
pos_named
# Write-Host ''
pos_named -verbose
# Write-Host ''
pos_named a b c -verbose
# Write-Host ''
pos_named a b c -file_name kekw -verbose
#>
<#
# "or" comparison
Write-Host ''
Write-Host '"or" comparison:'
function or_ps {
    Param([switch]$f, [switch]$force)
    Write-Host "$f"
    Write-Host "$force"
    Return($f -or $force)
}
Write-Host("$(or_ps)")
Write-Host(or_ps -f -force)
Write-Host (or_ps -force)
Write-Host(or_ps)
#>
<#
# static string: '' - expandable string: "" - https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7.3)
# equivalent to strings and formatted strings in python
$mynumber = 23
# f"{mynumber}" in python == "$($mynumber)" in pss
$staticstring = '$($mynumber)'
$expandablestring = "$($mynumber)"
Write-Host($staticstring)
Write-Host($expandablestring)
#>
# <#
# multiple lines strings
$multiple_lines_string = @'
first line
second line
'@
Write-Host($multiple_lines_string)
$mynumber = 56
$multiple_lines_formatted_string = @"
great number:
$($mynumber)
"@
Write-Host($multiple_lines_formatted_string)
#>
<#
# references: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_ref?view=powershell-7.3
# -> allows to change variables in place
function change_in_place {
    param ([ref]$ref) # parameter received by reference
    # $value.Value *= 2
    $ref.Value += " changed"
}
$mynumber = "original"
Write-Host($mynumber)
# convert to [ref] type to send only the ref of $mynumber
change_in_place([ref]$mynumber)
Write-Host($mynumber)
#>
<#
# pipeline functions:
function write_pipeline {
    begin {
        Write-Host "begin: the vars are of type $($input.GetType())"
        Write-Host "begin: the vars are $input"
    }
    # here, $input is filled with each item from the pipeline and empties them 1 by 1 in the process into $_
    # process {Write-Host "the var is: $_"}
    process {
        Write-Host "process: the vars are of type $($input.GetType())"
        Write-Host "process: the vars are $input"
        Write-Host "process: the var is: $PSItem"
    }
    # sends $PSItem down the pipeline
    # $input comes back empty
    end {Write-Host "end: the vars are of type $($input.GetType())"}
}
1,2,4 | write_pipeline
# write_pipeline @(1,2,4) # doesn't work => "write_pipeline" is not a pipe
# "filter" is a pipeline with only a process block:
filter my_filter {
    param ([switch]$add2)
    # if ($add2) {Write-Host "$($_ + 2)"}
    # else {Write-Host "$($_)"}
    if ($add2) {$PSItem + 2}
    else {$PSItem}
}
# 1,2,4 | my_filter
# 1,2,5 | my_filter -add2
# my_filter @(2,4,6,8) -add2 # doesn't work => "my_filter" is not a pipe; only 2 goes into $_
# my_filter 10 -add5 # doesn't work => same reason, nothing goes into $_
function is_positive { process {
    if ($_ -ge 0) {$True}
    else {$False}
}}
# 18 | is_positive
# -2.5, 7 | is_positive
# is_positive -5
# is_positive @(-10, 5, 35) # doesn't work
# regular function that expects a list of ints
function print_plus_five {
    param ([int[]]$ints_to_print)
    foreach ($int in $ints_to_print)
        {Write-Output ($int + 5)}
}
print_plus_five 1, 3, 5
print_plus_five 10
# 10 | print_plus_five
filter string_case_filter {
    param ([switch]$lower, [switch]$upper)
    # param checks:
        if (-not $($lower -xor $upper)) {Write-Error "set either the -lower or the -upper flag"; return $null}
        # if (!$PSItem) {return $null}
        $PSItem = [string] $PSItem # so that it returns an empty string if it filters an empty variable
    # $lower_case_chars =
    $PSItem
    # ...
}
'lol' | string_case_filter -lower
'lol' | string_case_filter -upper
# each element is processed down the pipeline before the next element is sent
1,2,3 | % {Write-Host "1st processing $_"; $($_ + 10), $($_ + 100)} | % {Write-Host "2nd processing $_"}
#>

<#
# advanced functions (cmdlets):
# https://powershellexplained.com/2020-03-15-Powershell-shouldprocess-whatif-confirm-shouldcontinue-everything/?utm_source=blog&utm_medium=blog&utm_content=recent
Function Get-Something {
    [CmdletBinding()]
    Param($item)
    Write-Host "You passed the parameter $item into the function"
    Write-Verbose "verbose stuff"
}
# Get-Something "lol" -verbose
Function Get-Something-2 { # this can exclusively be used as pipes
    [CmdletBinding()]
    Param([Parameter(ValueFromPipelineByPropertyName)]$Name) # properties of objects can be retrieved with Get-Members
    process {
        Write-Host "You passed the parameter $Name into the function"
        # Write-Verbose "verbose stuff"
    }
}
# Get-Service | Get-Something-2 -verbose
function Get-ItemMode {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]$Name,
        [Parameter(ValueFromPipelineByPropertyName)]$Mode
    )
    process {
        Write-Host "The item $Name has the mode $Mode"
    }
}
# dir "D:\code\personal_dump\code\powershell" | sort -Property "Name" | Get-ItemMode
function Test-CmdLet {
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Medium')]
    # [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string[]]$Path,
        [switch]$Force,
        [switch]$Confirm, # empty placeholder when using ShouldContinue
        [switch]$WhatIf
    )
    begin {
        $ConfirmPreference
        if ($Force) {
            # the 'Confirm' switch is not accessible, gotta look at the value of $ConfirmPreference
            # => High: bypass all confirmation
            # => Low: confirm every step
            # -Confirm takes precedence over -Force => talks directly to $PSCmdlet, unless $ConfirmPreference is forced to 'None'
            Write-Host '-Force flag is set'
            # $ConfirmPreference = 'High'
            $ConfirmPreference = 'Low'
            # $ConfirmPreference = 'None'
        }
        $ConfirmPreference
    }
    process {
        # $PSBoundParameters
        Write-Host $Path
        # $PSCmdlet | Get-Member
        $yes_to_all = $no_to_all = $False
        foreach ($path_to_process in $Path) {
            # if ($PSCmdlet.ShouldProcess('TARGET')) {
            # if ($PSCmdlet.ShouldProcess('TARGET', 'OPERATION')) {
            # if ($PSCmdlet.ShouldProcess('custom WhatIf message', 'TARGET', 'OPERATION')) {
            # if ($PSCmdlet.ShouldProcess('custom WhatIf message', 'custom Confirm message', '')) {
            # if (-not $Force -and $Confirm -and $PSCmdlet.ShouldContinue('Question', 'Title')) {
            # if (-not $Force -and $PSCmdlet.ShouldContinue('Are you sure?', '', [ref]$yes_to_all, [ref]$no_to_all)) {
                # Write-Host "doing the thing"
            # }
            if ($WhatIf) {
                $user_answer = $False
                Write-Host "What if: Custom WhatIf message"
            }
            elseif (-not $Force -and $Confirm) {
                # ShouldProcess
                # $user_answer = $PSCmdlet.ShouldProcess('custom WhatIf message', 'custom Confirm message', '')

                # ShouldContinue => always prompts by design; gotta implement -WhatIf ourselves
                # => impossible to use both in the same function
                # $WhatIf
                $user_answer = $PSCmdlet.ShouldContinue('Custom Confirm question', '')

                $user_answer
            }
            else {$user_answer = $True}
            if ($user_answer) {Write-Host "doing the thing"}
            # Write-Host $yes_to_all $no_to_all
        }
    }
    end {}
}
# $ConfirmPreference = 'Low'
$cmdlet_params = @{
    # 'Path' = '.\', '.\code\'
    'Path' = '.\'
    # 'Confirm' = $True
    # 'Verbose' = $True
    'WhatIf' = $True
    # 'Force' = $True
}
Test-CmdLet @cmdlet_params
#>

<#
# character number:
Write-Host ''
Write-Host 'character number:'
function char_number {
    param([char]$char)
    $([int]$char)
}
Write-Host $(char_number 'a')
Write-Host $(char_number 'z')
Write-Host $(char_number 'A')
Write-Host $(char_number 'Z')

# string colors:
Write-Host ''
Write-Host 'string colors:'
# "ESC" character
$esc = [char]27
Write-Host $(!!$esc) # is assigned
Write-Host $esc.GetType() # is a character
# gives the color character for the specific color number
function color_char_gen {
    param ([int]$char_number)
    "$($esc)[$($char_number)m"
}
# returns to the default color
$col_def = color_char_gen 0
# prints a list of strings with all available colors
# 30 -> 37 regular colors
# 90 -> 97 bright colors
#     Black
#     Red
#     Green
#     Yellow
#     Blue
#     Magenta
#     Cyan
#     White
function string_colors_print{
    for ($i = 30; $i -le 37; ++$i) {
        Write-Host "$(color_char_gen $i)This is a text in a color $(color_char_gen $($i + 60))This is a text in a bright color$($col_def)"
    }
}
string_colors_print
# $($col_Black)
# $($col_Red)
# $($col_Green)
# $($col_Yellow)
# $($col_Blue)
# $($col_Magenta)
# $($col_Cyan)
# $($col_White)
# $($bcol_Black)
# $($bcol_Red)
# $($bcol_Green)
# $($bcol_Yellow)
# $($bcol_Blue)
# $($bcol_Magenta)
# $($bcol_Cyan)
# $($bcol_White)
$color_name_array = @()
$color_name_array += "Black"
$color_name_array += "Red"
$color_name_array += "Green"
$color_name_array += "Yellow"
$color_name_array += "Blue"
$color_name_array += "Magenta"
$color_name_array += "Cyan"
$color_name_array += "White"
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
Write-Host "$($bcol_Cyan)This text is in Cyan$($col_def)"
# original:
# (workenv)
# PS D:\Code\personal_dump\code\powershell (main)
# > echo hello world
###
# new:
# (workenv)
# D:\Code\personal_dump\code\powershell (main)
# PS> echo hello world
###
# or:
# (workenv) C:\Users\Arthur (main)
# PS >
# $fake_prompt = @"
# ps:$($col_Red)>$($col_def)
# "@
# $fake_prompt_1 = @"
# $($bcol_Cyan)(workenv)
# $($bcol_Green)$($executionContext.SessionState.Path.CurrentLocation) $($col_Blue)(main)
# $($col_def)PS >
# "@$
# $fake_prompt_1 = "$($bcol_Cyan)(workenv)`n$($col_def)PS $($bcol_Green)$($executionContext.SessionState.Path.CurrentLocation) $($bcol_Blue)(main)`n$($col_def)> echo hello world"
# $fake_prompt_2 = "$($bcol_Cyan)(workenv)`n$($bcol_Green)$($executionContext.SessionState.Path.CurrentLocation) $($bcol_Blue)(main)`n$($col_Yellow)PS$($col_def)> echo hello world"
# $fake_prompt_3 = "$($bcol_Cyan)(workenv) $($bcol_Green)$($executionContext.SessionState.Path.CurrentLocation) $($bcol_Blue)(main)`n$($col_Yellow)PS$($col_def)> echo hello world"
# $fake_prompt_4 = "$($bcol_Cyan)(workenv)`n$($bcol_Green)$($executionContext.SessionState.Path.CurrentLocation) $($col_Red)(123abcd)`n$($col_Yellow)PS$($col_def)> echo hello world"
$fake_prompt_1 = "$($bcol_Cyan)(fakeenv)`n$($bcol_Green)A:\fake\place $($bcol_Blue)(git_branch)`n$($col_Yellow)PS$($col_def)> echo hello world"
$fake_prompt_2 = "$($bcol_Cyan)(fakeenv)`n$($bcol_Green)A:\fake\place`n$($col_Yellow)PS$($col_def)> echo hello world"
$fake_prompt_3 = "$($bcol_Green)A:\fake\place $($col_Red)(git_hash)`n$($col_Yellow)PS$($col_def)> echo hello world"
$fake_prompt_4 = "$($bcol_Green)A:\fake\place`n$($col_Yellow)PS$($col_def)> echo hello world"
Write-Host 'Prompt test:'
Write-Host ''
Write-Host $fake_prompt_1
Write-Host $fake_prompt_2
Write-Host $fake_prompt_3
Write-Host $fake_prompt_4
# Write-Host $fake_prompt_4
# new prompt validated => $fake_prompt_2

# aliases: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_alias_provider?view=powershell-7.3
# see all aliases
# alias
# set alias
# $alias:np = "c:\windows\notepad.exe"
New-Item -Path Alias:np -Value 'c:\windows\notepad.exe'
# cd
# use alias (opens notepad)
# np
# . $($alias:np)

# statements: https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-08?view=powershell-7.3
Write-Host ''
Write-Host 'statements:'
# if elif else
$test = 1
if ($test -eq 0) {Write-Host "is 0"}
elseif ($test -eq 1) {Write-Host "is 1"}
else {Write-Host "is neither"}

# while loop
# => evaluation before do
$i = 0
while ($i -lt 5) {
    Write-Host "while 5x"
    # $i += 1
    ++$i
}
# => evaluation after do
$i = 0
do {
    Write-Host "do 5x"
    ++$i
}
while ($i -lt 5)

# for loop
# "for (start, condition_to_continue, what_changes) {...}"
for ($i = 5; $i -ge 1; --$i) {
    Write-Host "for 5x too"
}

# for each
$a = 10, 53, 16, -43
foreach ($e in $a) {
    Write-Host "foreach $($e)"
}

# loop break
$i = 1
while ($true) { # infinite loop
    if ($i -gt 5) {
        break # break out of current while loop
    }
    Write-Host "break $i"
    ++$i
}

# loop skip
for ($i = 1; $i -le 10; ++$i) {
    if (($i % 2) -eq 1) {
        continue
    }
    Write-Host "continue $i"
}

# string char tests:
Write-Host ''
Write-Host 'string char tests:'
$space_char = [string][char]"`0"
# $space_char = [string][char]0
Write-Host $([int]$pace_char)
Write-Host "$($space_char.GetType())"
# Write-Host "haha $($space_char*5) blbl" -NoNewline; Write-Host "lol"
# "haha $($space_char*5) blbl"
Write-Host "first line`nsecond line"

# $null:
Write-Host ''
Write-Host '$null'
if ($null) {Write-Host '$null evaluates to $true'}
else {Write-Host '$null evaluates to $false'}
Write-Host "`"`$null`" evaluates to `$$([bool]$null)"
#>
<#
# verbose:
Write-Host ''
Write-Host 'verbose:'
function func_with_verbose {
    param([switch]$verbose)
    Write-Host 'This is a regular print'
    Write-Verbose 'This is a verbose print' -verbose $verbose
    Write-Verbose 'This is a force-printed verbose print' -verbose
}
# func_with_verbose
# func_with_verbose -verbose
function func_with_writeoutput {
    Write-Output 'child Write-Output string'
}
function parent_function {
    func_with_writeoutput
    Write-Output 'parent Write-Output string'
}
parent_function
Write-Host $(func_with_writeoutput)
Write-Host $(parent_function)
function f_test {Write-Host $(-not $([bool] $args.Length))}
f_test
f_test lol
f_test haha
#>
<#
# xor switches:
function two_switches {
    param([switch]$first, [switch]$second)
    Write-Host ($first -and $second)
    # Write-Host ($first -or $second)
    # Write-Host ($first -xor $second)
}
two_switches
two_switches -f
two_switches -s
two_switches -f -s
#>
<#
# drives: https://learn.microsoft.com/en-us/powershell/scripting/samples/managing-windows-powershell-drives?view=powershell-7.3
Write-Host ''
Write-Host 'drives:'
# $Env:CONDA_PROMPT_MODIFIER
$test = Get-PSDrive
# $test.gettype()
foreach ($item in $test) {
    # echo $item.provider.Name
    Write-Host $item.provider.Name
    if ($item.provider.Name -eq 'FileSystem') {
        # we are in a FileSystem drive, safe to look for git branches
        Write-Host 'safe to look for git branches'
    }
    else {
        # we are not in a FileSystem drive, don't do anything
        Write-Host "don't look for git branches"
    }
}
# $test[0]
# $test[0].provider
# $test[0].provider.name

# test if path is valid:
Test-Path -Path "D:\does\not\exist.txt" -IsValid
# the drive needs to exist
Test-Path -Path "G:\does\not\exist.txt" -IsValid
#>
<#
# $args:
function flags_parser {
    # param([int]$step)
    # Test-Path 'Variable:\args'
    # Write-Host $args
    $appendix_flag = $False
    foreach ($arg in $args) {
        $arg
        # type $arg
        if ($arg -match '^(--appendix|-a)$')
            {$appendix_flag = $True}
    }
    if ($appendix_flag) {Write-Output 'appendix flag detected'}
    else {Write-Output 'appendix flag not detected'}
}
# flags_parser
# flags_parser 1 lol 2 -5
# flags_parser 1 2 -5
flags_parser -a
flags_parser --appendix
flags_parser -a --appendix
flags_parser thing other_thing
flags_parser thing other_thing -a
flags_parser -a thing other_thing
# function Get-Type {
#     # param([switch]$display)
#     # Write-Host $display
#     foreach($arg in $args) {
#         # Write-Output $arg.GetType()
#         # $arg.GetType() | fl
#         # Write-Verbose $arg.GetType().FullName
#         # Write-Verbose "lol"
#         Write-Output $arg.GetType().FullName
#         # if ($display) {Write-Host "lol" $arg.GetType()}
#     }
# }
# $lol = 3
# Get-Type @() $lol 2 'a' @{} #$null => .GetType() doesn't work on $null
# @(), $lol, 2, 'a', @{} | Get-Type -verbose # Doesn't work
#>
<#
# RegEx:
# '$test_string -match $RegEx'
Write-Host ''
Write-Host 'RegEx:'
$regex_test = '-[\w]+'
$str_to_test = '-lolhaha'
$str_to_test -match $regex_test
$(!!$Matches)
$Matches
$Matches = $null
$str_to_test = '123'
$str_to_test -match $regex_test
$(!!$Matches)
$Matches
$Matches = $null
# try to get the name part of the path:
Write-Host 'new test:'
$file_path_test = 'D:\code\personal\code\powershell\test.txt'
$dir_path_test = 'D:\code\personal\code\powershell'
$regex_test = '\\([\w\-. ]+)$' # '^[\w\-. ]+$' https://stackoverflow.com/questions/11794144/regular-expression-for-valid-filename
$file_path_test -match $regex_test
$(!!$Matches)
# $Matches # 0: whole string - 1, 2 ...: groups captured
$Matches.1
$dir_path_test -match $regex_test
$(!!$Matches)
$Matches
$Matches.1

# ComObjects:
Write-Host ''
Write-Host 'ComObjects:'
# - delete a FileSystem object (file/dir/link):
# $shell = New-Object -ComObject "Shell.Application"
# $shellFolder = $shell.Namespace($directoryPath)
# $shellItem = $shellFolder.ParseName($Item.Name)
# $shellItem.InvokeVerb("delete")
$item_path_to_delete = "$HOME\to_delete.txt"
$item_parent_path_to_delete = Split-Path $item_path_to_delete -Parent
# touch $item_path_to_delete
$shell = New-Object -ComObject "Shell.Application"
# $shell | Get-Member | Format-Table Name,MemberType,Definition
$shell_dir = $shell.Namespace($item_parent_path_to_delete)
$shell_dir | Get-Member | Format-Table Name,MemberType,Definition
# $shell_dir_items = $shell_dir.Items()
# $shell_dir_items | Get-Member | Format-Table Name,MemberType,Definition
# $shell_dir_items | Format-Table Path,IsLink,IsFolder,IsFileSystem,Type
$item_path_to_delete -match $regex_test # use Resolve-Path to check existence instead
# $(!!$Matches)
# $Matches.1
$shell_item = $shell_dir.ParseName($Matches.1)
# $shell_item | Get-Member | Format-Table Name,MemberType,Definition
$shell_item.Name
# $shell_item.InvokeVerb("delete")
# - see all objects in trashcan:
$trashcan = $(New-Object -ComObject shell.application).Namespace(10)
$trashcan | Get-Member | Format-Table Name,MemberType,Definition
$trashcan_items = $trashcan.Items()
$trashcan_items | Get-Member | Format-Table Name,MemberType,Definition
@($trashcan_items) | Get-Member | Format-Table Name,MemberType,Definition
# $trashcan_items #| Format-Table Name
# $trashcan_items.IsFolder
# @($trashcan_items)[0] | Get-Member | Format-Table Name,MemberType,Definition
@($trashcan_items)[0] | Format-Table
# $trashcan | Get-Member | Format-Table Name,MemberType,Definition
# $trashcan.ParseName("Recycle")
# $trashcan_item = $trashcan.ParseName($Matches.1)
# $trashcan_item
#>
<#
# dynamic loader:
$scroll = "|/-\"
$idx = 0
$job = Invoke-Command -ComputerName $env:ComputerName -ScriptBlock { Start-Sleep -Seconds 10 } -AsJob
$origpos = $host.UI.RawUI.CursorPosition
# $origpos.Y += 1
while (($job.State -eq "Running") -and ($job.State -ne "NotStarted")) {
    $host.UI.RawUI.CursorPosition = $origpos
    Write-Host $scroll[$idx] -NoNewline
    $idx++
    if ($idx -ge $scroll.Length)
    {
        $idx = 0
    }
    Start-Sleep -Milliseconds 100
}
# It's over - clear the activity indicator.
$host.UI.RawUI.CursorPosition = $origpos
Write-Host 'Complete'
Remove-Variable('job')
$job = Start-Job -ScriptBlock { Start-Sleep -Seconds 10 }
while (($job.State -eq "Running") -and ($job.State -ne "NotStarted")) {
    Write-Host '.' -NoNewline
    Start-Sleep -Seconds 1
}
Write-Host ""
# Write-Progress
#>
<#
# try - catch - finally, trap:
# /!\ PowerShell doesn't crash; it just prints an error message (Write-Error), does nothing and moves on
# => "try" will try to catch that error message
try {
    Write-Host "try: before error"
    # NonSenseString
    # throw
    # @().split()
    # Write-Error "This is an error" # Doesn't count as an error
    Write-Host "try: after error" # this doesn't run if an error was caught earlier
}
catch { Write-Host "catch: caught the error" } # this only runs if an error was caught
finally { Write-Host "finally: this always writes" } # this always run
Write-Host "after finally: this always writes too"
#>
<#
# 0 -> 65535
# $all_chars_list = @()
for ($i = 33; $i -ge 0; ++$i) {
    # Write-Host $i $char
    # try { $all_chars_list += [char] $i }
    try {
        # [char] $i
        "$([char] $i) " | Out-File -FilePath "~\Desktop\all_chars.txt" -Append -Encoding "utf8" -NoNewline
    }
    catch {break}
    Write-Host $i $([char] $i)
    if ($($i % 100) -eq 0) {
        # Write-Host "lol"
        "" | Out-File -FilePath "~\Desktop\all_chars.txt" -Append
        "-" | Out-File -FilePath "~\Desktop\all_chars.txt" -Append
        # break
    }
    # if ($i -eq 600) {break}
}
# foreach ($char in $all_chars_list)
#>
<#
# prompt for choice:
# Confirm
# Are you sure you want to perform this action?
# Performing the operation "Remove File" on target "D:\code\personal_dump\code\powershell\test.txt".
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
$title = 'Confirm'
$question = "Are you sure you want to perform this action?`nPerforming the operation `"Remove File`" on target `"D:\code\personal_dump\code\powershell\lol.txt`"."
# $choices = '&Yes', '&No'
$choice_yes = New-Object -TypeName Management.Automation.Host.ChoiceDescription '&Yes', 'Continue with only the next step of the operation.'
$choice_yesall = New-Object -TypeName Management.Automation.Host.ChoiceDescription 'Yes to &All', 'Continue with all the steps of the operation.'
$choice_no = New-Object -TypeName Management.Automation.Host.ChoiceDescription '&No', 'Skip this operation and proceed with the next operation.'
$choice_noall = New-Object -TypeName Management.Automation.Host.ChoiceDescription 'No to A&ll', 'Skip this operation and all subsequent operations.'
$choice_suspend = New-Object -TypeName Management.Automation.Host.ChoiceDescription '&Suspend', 'Pause the current pipeline and return to the command prompt. Type "exit" to resume the pipeline.'
$choices = $choice_yes, $choice_yesall, $choice_no, $choice_noall, $choice_suspend
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
$decision
# $host.EnterNestedPrompt()
# $host.ExitNestedPrompt()
# if ($decision -eq 0) {
#     Write-Host 'confirmed'
# } else {
#     Write-Host 'cancelled'
# }
#>
<#
# give the choice to output URL, or start a new server anyways
# 0) output URLs
# 1) start new server anyways
# 2) suspend (start nested prompt)
$table = @{
    0 = @('Output &URL', 'Display the login URL of all the servers running.');
    1 = @('Start &New server', 'Start a new Jupyter Lab server.');
    2 = @('&Suspend', 'Pause this command and enter a nested prompt. Type "exit" to resume.')
}
# $table
# $table | Get-Member
# $table.Count
# # foreach ($key in $table.Keys) {$key}
# $table.Keys | % {$_} | sort
# $Table.Values | % {$_}
confirmation_prompt -q 'A Jupyter Lab server is already running. Please advise:' -c $table -d 0
#>

<#
# progress bar:
function Write-Status {
    param(
        [int] $Current,
        [int] $Total,
        [string] $Statustext,
        [string] $CurStatusText,
        [int] $ProgressbarLength = 35
    )

    # Save current Cursorposition for later
    # $org_pos = $host.UI.RawUI.CursorPosition

    # Create Progressbar
    $progressbar = ''
    $progress = $([math]::Round($(([math]::Round(($($Current) / $Total) * 100, 2) * $ProgressbarLength) / 100), 0))
    for ($i = 0 ; $i -lt $progress; $i++) {
        $progressbar = $progressbar + $([char]9608) # white square
    }
    for ($i = 0 ; $i -lt ($ProgressbarLength - $progress); $i++) {
        $progressbar = $progressbar + $([char]9617) # space
    }
    # Overwrite Current Line with the current Status
    # Write-Host -NoNewline "`r$Statustext $progressbar [$($Current.ToString("#,###").PadLeft($Total.ToString("#,###").Length)) / $($Total.ToString("#,###"))] ($($( ($Current / $Total) * 100).ToString("##0.00").PadLeft(6)) %) $CurStatusText"

    Write-Host "$Statustext $progressbar [$($Current.ToString("#,###").PadLeft($Total.ToString("#,###").Length)) / $($Total.ToString("#,###"))] ($($( ($Current / $Total) * 100).ToString("##0.00").PadLeft(6)) %) $CurStatusText"
    # $host.UI.RawUI.CursorPosition = $org_pos

    # There might be old Text behing the current Cursor, so let's write some blanks to the Position of $XOrg
    # [int]$XNow = $host.UI.RawUI.CursorPosition.X
    # for ([int]$i = $XNow; $i -lt $XOrg; $i++) {
    #     Write-Host -NoNewline " "
    # }
    # Just for optical reasons: Go back to the last Position of current Line
    # for ([int]$i = $XNow; $i -lt $XOrg; $i++) {
    #     Write-Host -NoNewline "`b"
    # }
}
# clear
$list_test = @(1,2,3,4,5)
$org_pos = $host.UI.RawUI.CursorPosition
for ($i=0; $i -lt $list_test.Count; $i++) {
    # Write-Status -Current $i -Total 10 -Statustext "Running a long Task" -CurStatusText "Working on Position $i"
    [Console]::SetCursorPosition($org_pos.X,$org_pos.Y)
    # ...
    $list_test[0..$i]
    Start-Sleep 1
}
#>

<#
# read file
$index_last_line_printed = -1
for ($i = 0; $i -le 5; ++$i) {
    # $index_last_line_printed
    $index_line = 0
    foreach ($line in $(read .\test.txt)) {
        if ($index_line -gt $index_last_line_printed) {
            Write-Host "line #${index_line}:" $line
            $index_last_line_printed = $index_line
        }
        ++$index_line
    }
}
#>

<#
# ErrorRecords:
function MyCmdlet {
    [CmdletBinding()]
    param()
    $PSCmdlet.WriteVerbose("before")
    $Exception = [Exception]::new("error message")
    $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
        $Exception,
        "errorID",
        [System.Management.Automation.ErrorCategory]::NotSpecified,
        # $TargetObject # usually the object that triggered the error, if possible
        $null
    )
    $PSCmdlet.WriteError($ErrorRecord)
    # $PSCmdlet.ThrowTerminatingError($ErrorRecord)
    $PSCmdlet.WriteVerbose("after")
}
MyCmdlet -v
#>

<#
# cmdlet begin-process-end:
function MyCmdletProcess {
    [CmdletBinding()]
    param([Parameter(ValueFromPipeline)] [int[]] $int_pipeline_input)
    begin {
        Write-Host 'begin block'
        Write-Host "begin: the vars are of type $(type $input)"
        Write-Host "begin: the vars are ${input}"
        Write-Host "begin: there are $($input.Count) vars"
        Write-Host "begin: `$int_pipeline_input: ${int_pipeline_input}"
    }
    process {
        Write-host 'process block'
        Write-Host "process: the vars are of type $(type $input)"
        Write-Host "process: the vars are $input"
        Write-Host "process: the var is of type $(type $PSItem)"
        Write-Host "process: the var is $PSItem"
        Write-Host "process: `$int_pipeline_input: ${int_pipeline_input}"
        Write-Host "process: type `$int_pipeline_input: $(type $int_pipeline_input)"
    }
    end {
        Write-Host 'end block'
        Write-Host "end: the vars are of type $(type $input)"
        Write-Host "end: the vars are $input"
    }
}
# MyCmdletProcess
1, 3, 5 | MyCmdletProcess
# 6 | MyCmdletProcess
# MyCmdletProcess -int_pipeline_input @(3,4,5)

# both work the same way:
# => rm -Path @('.\test1.txt', '.\test2.txt') -Confirm
# => @('.\test1.txt', '.\test2.txt') | rm -Confirm
#>

<#
TODO:
- "touch" with "New-Item"
- symbolic links with "New-Item"
- remake conda prompt
- put profile stuff in separate file on personal_dump ?
#>

# write to console: "echo", "Write-Output", "Write-Host"

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
[char]"a"
[string][char]"a"
[bool]10

# assign value to variable, delete variable:
Write-Host ''
Write-Host 'variables:'
$myvar = 10
Write-Host(!!$myvar)
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
Write-Host ""
Write-Host 'positional + named parameters:'
function pos_named{
    Param([switch]$verbose, [string]$file_name)
    if ($verbose) {Write-Host "verbose on"}
    else {Write-Host "verbose off"}
    Write-Host "$(is_var_assigned $args)"
    Write-Host $args
    Write-Host $file_name
}
Write-Host ""
pos_named
Write-Host ""
pos_named -verbose
Write-Host ""
pos_named a b c -verbose
Write-Host ""
pos_named a b c -file_name kekw -verbose

# "or" comparison
Write-Host ""
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

# static string: '' - expandable string: "" - https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7.3)
# equivalent to strings and formatted strings in python
$mynumber = 23
# f"{mynumber}" in python == "$($mynumber)" in pss
$staticstring = '$($mynumber)'
$expandablestring = "$($mynumber)"
Write-Host($staticstring)
Write-Host($expandablestring)

# multiple lines strings
$multiple_lines_string = @'
first line
second line
'@
Write-Host($multiple_lines_string)
$multiple_lines_formatted_string = @"
great number:
$($mynumber)
"@
Write-Host($multiple_lines_formatted_string)

# references (allows to change variables in place):
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

# pipeline:
function write_pipeline {
    begin{Write-Host "the vars are $input"}
    # here, $input is filled with each item from the pipeline and empties them 1 by 1 in the process into $_
    process {Write-Host "the var is: $_"}
    # $input comes back empty
    end{Write-Host "the vars are $input"}
}
1,2,4 | write_pipeline
# "filter" is a pipeline with only a process block:
filter my_filter {
    param([switch]$add2)
    if ($add2) {Write-Host "$($_ + 2)"}
    else {Write-Host "$($_)"}
}
1,2,4 | my_filter
1,2,5 | my_filter -add2

# character number:
Write-Host ""
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
Write-Host ""
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
$fake_prompt_1 = "$($bcol_Cyan)(workenv)`n$($col_def)PS $($bcol_Green)$($executionContext.SessionState.Path.CurrentLocation) $($bcol_Blue)(main)`n$($col_def)> echo hello world"
$fake_prompt_2 = "$($bcol_Cyan)(workenv)`n$($bcol_Green)$($executionContext.SessionState.Path.CurrentLocation) $($bcol_Blue)(main)`n$($col_Yellow)PS$($col_def)> echo hello world"
$fake_prompt_3 = "$($bcol_Cyan)(workenv) $($bcol_Green)$($executionContext.SessionState.Path.CurrentLocation) $($bcol_Blue)(main)`n$($col_Yellow)PS$($col_def)> echo hello world"
$fake_prompt_4 = "$($bcol_Cyan)(workenv)`n$($bcol_Green)$($executionContext.SessionState.Path.CurrentLocation) $($col_Red)(123abcd)`n$($col_Yellow)PS$($col_def)> echo hello world"
Write-Host 'Prompt test:'
# Write-Host ''
# Write-Host $fake_prompt_1
# Write-Host $fake_prompt_1
# Write-Host $fake_prompt_1
# Write-Host $fake_prompt_1
# Write-Host $fake_prompt_1
Write-Host ''
Write-Host $fake_prompt_2
Write-Host $fake_prompt_2
Write-Host $fake_prompt_2
Write-Host $fake_prompt_2
Write-Host $fake_prompt_2
Write-Host ''
Write-Host $fake_prompt_4
Write-Host $fake_prompt_4
Write-Host $fake_prompt_4
Write-Host $fake_prompt_4
Write-Host $fake_prompt_4
Write-Host ''
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
Write-Host ""
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

$space_char = [string][char]"`0"
# $space_char = [string][char]0
Write-Host $([int]$pace_char)
Write-Host "$($space_char.GetType())"
# Write-Host "haha $($space_char*5) blbl" -NoNewline; Write-Host "lol"
# "haha $($space_char*5) blbl"
Write-Host "first line`nsecond line"

if ($null) {Write-Host '$null evaluates to $true'}
else {Write-Host '$null evaluates to $false'}
Write-Host "`"`$null`" evaluates to `$$([bool]$null)"

# drives: https://learn.microsoft.com/en-us/powershell/scripting/samples/managing-windows-powershell-drives?view=powershell-7.3
Write-Host ""
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

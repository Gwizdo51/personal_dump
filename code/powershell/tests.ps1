<#
TODO:
- "touch" with "New-Item"
=> make powershell notes file
- symbolic links with "New-Item"
- remake conda prompt
- put profile stuff in separate file on personal_dump ?
#>

# write to console: "echo", "Write-Output", "Write-Host"

# access types properties and methods: Get-Member - https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-04?view=powershell-7.3

# get the type: https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-04?view=powershell-7.3
Write-Output('types:')
Write-Output("$((10).GetType())")
# value types:
    # null reference (unassignable variable)
    $null = 10; Write-Output(!!$null)
    # [bool], [switch]
    Write-Output("$true $false")
    # [char]
    # "| Out-String" to get full output of GetType
    # Write-Output("$(([char]'f').GetType() | Out-String)")
    Write-Output("$(([char]'f').GetType()) $([char]'f')")
    Write-Output([char]::IsDigit('0'))
    # [int]
    Write-Output("$((5).GetType()) $([int]5)")
    Write-Output([int]::MinValue)
    # [byte]
    Write-Output("$(([byte]36).GetType()) $([byte]36)")
    Write-Output([byte]::MaxValue)
    # [single], [float] (32 bit)
    Write-Output("$(([single]3.6).GetType()) $([single]3.6)")
    Write-Output([single]::NaN)
    # [double] (64 bit)
    Write-Output("$((-17.58).GetType()) $(-17.58)")
    Write-Output([double]::PositiveInfinity)
    # [decimal] (128 bit)
    Write-Output("$(([decimal]132.586).GetType()) $([double]132.586)")
    Write-Output([decimal]::MaxValue)
# reference types:
    # [string]
    Write-Output("$(('abc').GetType()) $('abc')")
    Write-Output("$(('abc').Length)")
    # Write-Output("$(('abc').GetType() | Out-String)")
    # [Array]
    $my_array = 1,2,3; Write-Output($my_array); Write-Output("$($my_array)")
    Write-Output("$(($my_array).GetType()) $($my_array)")
    # Write-Output("$(($my_array).GetType() | Out-String)")
    Write-Output("$(($my_array).GetType())")
    # [Hashtable]
    $my_hastable = @{
        first_name = "John";
        last_name = "Doe";
        id = 123
    }
    Write-Output("$($my_hastable.first_name)")
    Write-Output("$($my_hastable["last_name"])")
    Write-Output("$($my_hastable.Keys)")
    Write-Output("$($my_hastable.Values)")

# get the type:
# Write-Output($true.GetType())
# Write-Output("$($true.GetType() | Out-String)")

# convert types:
[char]"a"
[string][char]"a"
[bool]10

# assign value to variable, delete variable:
Write-Output ''
Write-Output 'variables:'
$myvar = 10
Write-Output(!!$myvar)
# Remove-Variable
$myvar = $null
Write-Output(!!$myvar)
# convert variable type

# assign function return value to variable:
function add {
    Param([int]$value_1=0, [int]$value_2=0)
    $sum = $value_1 + $value_2
    return $sum
}
$lol = add -value_2 5
$lol2 = $(add 1 (-10))
Write-Output($lol)
Write-Output($lol2)
Write-Output "$(add -value_1 (-4) -value_2 2)"
Write-Output "$(add)"

# assignment test
function is_var_assigned {
    Param($var)
    # Write-Output($var)
    return (!!$var)
}
Write-Output("$(is_var_assigned($null))")
$my_var = 10
Write-Output("$(is_var_assigned($my_var))")

# positional + named parameter
Write-Output ""
Write-Output 'positional + named parameters:'
function pos_named{
    Param([switch]$verbose, [string]$file_name)
    if ($verbose) {Write-Output "verbose on"}
    else {Write-Output "verbose off"}
    Write-Output "$(is_var_assigned $args)"
    Write-Output $args
    Write-Output $file_name
}
Write-Output ""
pos_named
Write-Output ""
pos_named -verbose
Write-Output ""
pos_named a b c -verbose
Write-Output ""
pos_named a b c -file_name kekw -verbose

# "or" comparison
Write-Output ""
Write-Output '"or" comparison:'
function or_ps {
    Param([switch]$f, [switch]$force)
    Write-Output "$f"
    Write-Output "$force"
    Return($f -or $force)
}
Write-Output("$(or_ps)")
Write-Output(or_ps -f -force)
Write-Output (or_ps -force)
Write-Output(or_ps)

# static string: '' - expandable string: "" - https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7.3)
# equivalent to strings and formatted strings in python
$mynumber = 23
# f"{mynumber}" in python == "$($mynumber)" in pss
$staticstring = '$($mynumber)'
$expandablestring = "$($mynumber)"
Write-Output($staticstring)
Write-Output($expandablestring)

# multiple lines strings
$multiple_lines_string = @'
first line
second line
'@
Write-Output($multiple_lines_string)
$multiple_lines_formatted_string = @"
great number:
$($mynumber)
"@
Write-Output($multiple_lines_formatted_string)

# references (allows to change variables in place):
function change_in_place {
    param ([ref]$ref) # parameter received by reference
    # $value.Value *= 2
    $ref.Value += " changed"
}
$mynumber = "original"
Write-Output($mynumber)
# convert to [ref] type to send only the ref of $mynumber
change_in_place([ref]$mynumber)
Write-Output($mynumber)

# pipeline:
function write_pipeline {
    begin{Write-Output "the vars are $input"}
    # here, $input is filled with each item from the pipeline and empties them 1 by 1 in the process into $_
    process {Write-Output "the var is: $_"}
    # $input comes back empty
    end{Write-Output "the vars are $input"}
}
1,2,4 | write_pipeline
# "filter" is a pipeline with only a process block:
filter my_filter {
    param([switch]$add2)
    if ($add2) {Write-Output "$($_ + 2)"}
    else {Write-Output "$($_)"}
}
1,2,4 | my_filter
1,2,5 | my_filter -add2

# statements: https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-08?view=powershell-7.3
Write-Output ""
Write-Output 'statements:'
# if elif else
$test = 1
if ($test -eq 0) {Write-Output "is 0"}
elseif ($test -eq 1) {Write-Output "is 1"}
else {Write-Output "is neither"}

# while loop
# => evaluation before do
$i = 0
while ($i -lt 5) {
    Write-Output "while 5x"
    # $i += 1
    ++$i
}
# => evaluation after do
$i = 0
do {
    Write-Output "do 5x"
    ++$i
}
while ($i -lt 5)

# for loop
# "for (start, condition_to_continue, what_changes) {...}"
for ($i = 5; $i -ge 1; --$i) {
    Write-Output "for 5x too"
}

# for each
$a = 10, 53, 16, -43
foreach ($e in $a) {
    Write-Output "foreach $($e)"
}

# loop break
$i = 1
while ($true) { # infinite loop
    if ($i -gt 5) {
        break # break out of current while loop
    }
    Write-Output "break $i"
    ++$i
}

# loop skip

for ($i = 1; $i -le 10; ++$i) {
    if (($i % 2) -eq 1) {
        continue
    }
    Write-Output "continue $i"
}

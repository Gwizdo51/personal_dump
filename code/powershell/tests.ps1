<#
TODO:
- "touch" with "New-Item"
=> make powershell notes file
- symbolic links with "New-Item"
- remake conda prompt
#>

# write to console: "echo", "Write-Output", "Write-Host"

# access types properties and methods: Get-Member - https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-04?view=powershell-7.3
# get the type:
# Write-Output((10).GetType())
Write-Output("$((10).GetType())")
# value types:
    # null reference (unassignable variable)
    $null = 10; Write-Output(!!$null)
    # boolean (switch)
    Write-Output("$true $false")
    # char
    Write-Output("$(([char]"f").GetType()) $([char]"f")")
    Write-Output([char]::IsDigit("0"))
    # int
    Write-Output("$((5).GetType()) $([int]5)")
    Write-Output([int]::MinValue)
    # byte
    Write-Output("$(([byte]36).GetType()) $([byte]36)")
    Write-Output([byte]::MaxValue)
    # single, float (32 bit)
    Write-Output("$(([single]3.6).GetType()) $([single]3.6)")
    Write-Output([single]::NaN)
    # double (64 bit)
    Write-Output("$((-17.58).GetType()) $(-17.58)")
    Write-Output([double]::PositiveInfinity)
    # decimal (128 bit)
    Write-Output("$(([decimal]132.586).GetType()) $([double]132.586)")
    Write-Output([decimal]::MaxValue)
# reference types:
    # string (static string: '' - expandable string: "" - https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7.3)
    'abc'.GetType()
# array:
$array = 1,2,3; Write-Output($array)

# get the type:
Write-Output($true.GetType())
Write-Output("$($true.GetType())")

# convert types:
[char]"a"
[string][char]"a"
[bool]10

# assign value to variable, delete variable:
$myvar = 10
Write-Output(!!$myvar)
# Remove-Variable ...
Write-Output(!!$myvar)
# convert variable type
# assign function return value to variable
function add {
    Param($value_1, $value_2)
    $sum = ($value_1 + $value_2)
    return $sum
}
Write-Output(add(1, 2))
# $function_return = "$(assign_to_variable)"
# Write-Output($function_return)

# assignment test
function is_var_assigned {
    Param($var)
    Write-Output($var)
    return (!!$var)
}
Write-Output(is_var_assigned($function_return))
# $returned_value = "$(is_var_assigned)"
# Write-Output "$returned_value"

# "or" comparison
function or_ps {
    Param([switch]$f, [switch]$force)
    # Write-Output "$f"
    # Write-Output "$force"
    $force_or = $f -or $force
    Write-Output "$force_or"
}
# Write-Output("$(or_ps)")
# Write-Output or_ps -f -force
# Write-Output or_ps -force
# Write-Output or_ps

# references: (allows to change variables in place)
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

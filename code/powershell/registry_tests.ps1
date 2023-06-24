# $product_codes = $(Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall)
# $product_codes.GetType()
# $product_code[0].GetType()

# Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | ForEach-Object -Process {
#     # Write-host $(Get-Member -InputObject $_)
#     Get-Member
#     break
# }

$uninstall_reg_path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

# Get-ChildItem $uninstall_reg_path | Get-Member -static
# Get-ChildItem $uninstall_reg_path | Get-Member -MemberType Properties
# Get-ChildItem $uninstall_reg_path | Get-Member -MemberType Method
# Get-ChildItem $uninstall_reg_path | Write-Host

# Get-ChildItem $uninstall_reg_path | Format-Table -Property Name, SubKeyCount, ValueCount
# Get-Item $uninstall_reg_path | Format-Table -Property Name, SubKeyCount, ValueCount
# Get-ChildItem $uninstall_reg_path | Get-Item

$uninstall_reg_item_path = "$uninstall_reg_path\{8BBCB5E9-5775-4465-AABC-3E276EBBD496}"
# Get-Item $uninstall_reg_item_path
# Get-ItemPropertyValue $uninstall_reg_item_path -Name "DisplayName"

# Get-ChildItem $uninstall_reg | Get-ItemPropertyValue -Path $_ -Name "DisplayName"
# Get-ChildItem $uninstall_reg_path | Write-Host

$items = @(Get-ChildItem $uninstall_reg_path)
# foreach ($item in $items) {Get-ItemPropertyValue -Path $item -Name "DisplayName"}
foreach ($item in $items) {
    # $item | Get-Member
    # $item.Property
    # Get-ItemPropertyValue -Path $item -Name "DisplayName"
    # Write-Host ""
    # break
    # Get-ItemPropertyValue -Path $item.Name -Name "DisplayName"
}
# $items.GetType()

# Get-Item -Path $uninstall_reg_item_path | Get-ItemPropertyValue -Name DisplayName
# Get-ChildItem -Path $uninstall_reg_path | Get-ItemPropertyValue -Name DisplayName
Get-ChildItem -Path $uninstall_reg_path | Get-ItemProperty -Name DisplayName

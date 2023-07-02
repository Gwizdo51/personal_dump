# custom profile
param(
    [switch]$Silent
)
$custom_profile = "D:\code\personal_dump\code\powershell\profile\windows_custom_profile.ps1"
. $custom_profile -Silent:$Silent

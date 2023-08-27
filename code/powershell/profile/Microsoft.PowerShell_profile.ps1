# custom profile
param([switch]$Silent, [switch]$Verbose)
$custom_profile = "D:\code\personal_dump\code\powershell\profile\windows_custom_profile.ps1"
. $custom_profile -Silent:$Silent -Verbose:$Verbose

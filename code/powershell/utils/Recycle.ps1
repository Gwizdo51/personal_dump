# function rmd {
#     param([switch]$f, [switch]$force)
#     if ($f -or $force) {Remove-Item $args -r -force}
#     else {Remove-Item $args -r}
# }
function Recycle { # move items to trash on "rm" calls
    [CmdletBinding(DefaultParameterSetName='Path', SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)] # check pipeline
        [SupportsWildcards()] # check wildcards (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-7.3)
        [string[]] $Path, # should be able to take a list of paths
        [switch] $Yes
    )
    # get the absolute path of the item + check if item exists
    # try - catch here
    $path_is_valid = Test-Path $Path
    if (-not $path_is_valid) {Write-Error "$Path does not exist"; return $null}
    $absolute_path = Resolve-Path $Path
    Write-Verbose "Recycling the item at the path $absolute_path"
    $item_to_recycle = Get-Item $absolute_path -Force
    # $item_to_delete = Get-Item $Path
    # $item_to_delete | Get-Member | ft
    # type $item_to_delete
    # check if the drive provider is a FileSystem
    $provider = $item_to_recycle.PSDrive.Provider.Name
    if ($provider -ne 'FileSystem') {throw 'Can only recycle files, folders and links'}
    # if $item_to_recycle is the root of a drive, fail here
    # $provider_root = $item_to_recycle.PSDrive.Root
    $all_filesystem_roots = (Get-PSDrive | where {$_.provider.name -eq 'FileSystem'}).root
    # $all_filesystem_roots
    if ($absolute_path -in $all_filesystem_roots) {throw 'Cannot recycle a FileSystem root'}
    $parent_dir_path = Split-Path $absolute_path -Parent
    $item_name = Split-Path $absolute_path -Leaf
    # Write-Host $parent_dir_path
    # Write-Host $path_item_name
    $shell = New-Object -ComObject 'Shell.Application'
    $shell_dir = $shell.Namespace($parent_dir_path)
    $shell_item = $shell_dir.ParseName($item_name)
    # $shell_item | Get-Member
    # return
    # request confirmation if the item is a folder (doesn't matter if it's a link)
    if ($shell_item.IsFolder -and !($shell_item.IsLink) -and !$yes) {
        $original_confirmation_message = "Confirm recycling folder '$absolute_path' ([Y]es/No)"
        $confirmation_message = $original_confirmation_message
        # while (-not $(Test-Path 'Variable:\confirmed')) {
        while (!(Test-Path 'Variable:/user_confirmation')) {
            $user_input = Read-Host $confirmation_message
            # default to yes
            if ($user_input -eq "") {$user_input = 'y'}
            # use RegEx here
            if ($user_input -match '^([yn]|yes|no)$') {
                # set $user_confirmation
                switch ($matches.0) {
                    "y" { $user_confirmation = $True }
                    "yes" { $user_confirmation = $True }
                    "n" { $user_confirmation = $False }
                    "no" { $user_confirmation = $False }
                    default { throw 'smth went wrong' }
                }
            }
            else {$confirmation_message = "Did not understand.`n$original_confirmation_message"}
        }
        if (!(Test-Path 'Variable:/user_confirmation')) {throw 'smth went wrong'}
    }
    return "prout"
    # at this point, $user_confirmation is either not set if the item is a file,
    # or set to true/false if the item is a folder
    if (!(Test-Path 'Variable:/user_confirmation')) {
        $shell_item.InvokeVerb('delete')
    }
    elseif ($user_confirmation) {
        $shell_item.InvokeVerb('delete')
    }
    # check success
    $path_exists = Test-Path $absolute_path
    if ($path_exists) {Write-Error 'Some items were not removed'}
    else {Write-Host "Moved '$($color_characters_dict.col_Red)$($absolute_path)$($color_characters_dict.col_def)' to the recycle bin"}
}
New-Item -Path Alias:rc -Value Recycle -Force > $null
function Open-RecyleBin {start shell:RecycleBinFolder}
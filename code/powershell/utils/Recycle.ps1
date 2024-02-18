# function rmd {
#     param([switch]$f, [switch]$force)
#     if ($f -or $force) {Remove-Item $args -r -force}
#     else {Remove-Item $args -r}
# }
<#
function Recycle-Item { # move items to trash on "rm" calls
    # needs to check if recycle is used on an item from the FileSystem drive
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)] # check pipeline
        [SupportsWildcards()] # check wildcards (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-7.3)
        [string[]] $Path, # should be able to take a list of paths
        [switch] $Yes
    )
    # get the absolute path of the item + check if item exists
    $path_is_valid = Test-Path $Path
    if (-not $path_is_valid) {
        # Write-Error "$Path does not exist"; return $null
        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException] 'No jupyter server is currently running',
            'NoRunningServer',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $null
        )
        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
    }
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
    # request confirmation if the item is a folder (doesn't matter if it's a link) -> maybe not ?
    if ($shell_item.IsFolder -and !($shell_item.IsLink) -and !$Yes) {
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
    # add a recycle sound effect ? https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-play-wav-files/
    # check success
    $path_exists = Test-Path $absolute_path
    if ($path_exists) {Write-Error 'Some items were not removed'}
    else {Write-Host "Moved '$($color_characters_dict.col_Red)$($absolute_path)$($color_characters_dict.col_def)' to the recycle bin"}
}
#>

function Recycle-Item {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)] # check pipeline
        [SupportsWildcards()] # check wildcards (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-7.3)
        [string[]] $Path # should be able to take a list of paths
    )
    begin {
        $all_filesystem_roots = (Get-PSDrive | where {$_.provider.name -eq 'FileSystem'}).root
        $shell = New-Object -ComObject 'Shell.Application'
    }
    process {
        foreach ($path_item in $Path) {
            # Write-Host "recycling '${path_item}'"
            if (!(Test-Path $path_item)) {
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.IO.FileNotFoundException] "Cannot find path '${path_item}' because it does not exist",
                    'ItemNotFound',
                    [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                    $path_item
                )
                $PSCmdlet.WriteError($ErrorRecord)
                continue
            }
            # Write-Host "recycling '${path_item}'"
            # make a pipeline to delete all items pointed by $path_item
            $path_item | Get-Item -Force | ? {
                # check if the item is a FileSystem item
                if ($_.PSProvider.Name -eq 'FileSystem') {$True}
                else {
                    $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                        [System.InvalidOperationException] 'Can only recycle files, folders and links',
                        'InvalidProvider',
                        [System.Management.Automation.ErrorCategory]::PermissionDenied,
                        $_
                    )
                    $PSCmdlet.WriteError($ErrorRecord)
                    $False
                }
            } | ? {
                # check if the item is the root of a drive
                if ($_.FullName -in $all_filesystem_roots) {
                    $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                        [System.ArgumentException] 'Cannot recycle a FileSystem root',
                        'InvalidItem',
                        [System.Management.Automation.ErrorCategory]::InvalidArgument,
                        $_
                    )
                    $PSCmdlet.WriteError($ErrorRecord)
                    $False
                }
                else {$True}
            } | ? {$PSCmdlet.ShouldProcess($_, 'Recycle')} | % {
                # $_
                $parent_dir_path = Split-Path $_.FullName -Parent
                # $item_name = Split-Path $_.FullName -Leaf
                # $parent_dir_path, $item_name
                # $shell = New-Object -ComObject 'Shell.Application'
                $shell_dir = $shell.Namespace($parent_dir_path)
                $shell_item = $shell_dir.ParseName($_.Name)
                # $shell_item
                $shell_item.InvokeVerb('Delete')
            }
        }
    }
}
New-Item -Path Alias:ri -Value Recycle-Item -Force > $null

function Open-RecyleBin {start shell:RecycleBinFolder}
New-Item -Path Alias:orb -Value Open-RecyleBin -Force > $null

# list all recycled items: (New-Object -ComObject shell.application).Namespace(10).Items()
# access specific recycled item:
# $recycled_items = (New-Object -ComObject shell.application).Namespace(10).Items()
# @($recycled_items)[0]

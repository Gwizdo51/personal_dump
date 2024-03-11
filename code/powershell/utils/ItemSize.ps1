function Convert-Bytes2Human {
    param([int64] $ByteCount)
    # $human_size = $Bytes
    if ($ByteCount -eq 0) {
        $human_size = "${ByteCount} B"
    }
    else {
        switch ([math]::Truncate([math]::Log($ByteCount, 1024))) {
            0 {$human_size = "${ByteCount} B"}
            1 {$human_size = "{0:n1} KB" -f ($ByteCount / 1KB)}
            2 {$human_size = "{0:n1} MB" -f ($ByteCount / 1MB)}
            3 {$human_size = "{0:n1} GB" -f ($ByteCount / 1GB)}
            4 {$human_size = "{0:n1} TB" -f ($ByteCount / 1TB)}
            default {$human_size = "{0:n1} PB" -f ($ByteCount / 1PB)}
        }
    }
    return $human_size
}

function Get-ItemSize {
    # returns the size of the item given as input
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)] [string[]] $LiteralPath,
        [switch] $Force,
        [switch] $HumanReadable
    )
    process {
        foreach ($path_item in $LiteralPath) {
            # check if path_item exists
            if (-not (Test-Path -LiteralPath $path_item)) {
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.InvalidOperationException] "Cannot find path '${path_item}' because it does not exist, or is not literal",
                    'InvalidPath',
                    [System.Management.Automation.ErrorCategory]::InvalidOperation,
                    $path_item
                )
                $PSCmdlet.WriteError($ErrorRecord)
                continue
            }
            $item = Get-Item -Force:$Force -LiteralPath $path_item
            # check if in a FileSystem drive
            if ($item.PSProvider.Name -ne 'FileSystem') {
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.InvalidOperationException] 'Not in a FileSytem drive',
                    'InvalidProvider',
                    [System.Management.Automation.ErrorCategory]::PermissionDenied,
                    $path_item
                )
                $PSCmdlet.WriteError($ErrorRecord)
                continue
            }
            $PSCmdlet.WriteVerbose("Getting the size of '$($item.FullName)'")
            if ($item.Mode -match 'l') {
                $item_size = 0
            }
            elseif ($item.Mode -match 'd') {
                # $PSCmdlet.WriteVerbose("'${path_item}' is a directory")
                # sum the size of all the items in the directory
                # $dir_size = 0
                # foreach ($child_item in Get-ChildItem -LiteralPath $item.FullName -Force:$Force) {
                #     $dir_size += Get-ItemSize $child_item.FullName -Force:$Force
                # }
                # Get-ChildItem -LiteralPath $item.FullName -Force:$Force | % {
                #     $dir_size += Get-ItemSize -LiteralPath $_.FullName -Force:$Force
                # }
                $dir_size = Get-ChildItem -LiteralPath $item.FullName -Force:$Force |
                    % {Get-ItemSize -LiteralPath $_.FullName -Force:$Force} |
                    Measure-Object -Sum
                $item_size = [int64] $dir_size.Sum
            }
            else {
                $item_size = [int64] $item.Length
            }
            if ($HumanReadable) {$item_size = Convert-Bytes2Human $item_size}
            $PSCmdlet.WriteObject($item_size)
        }
    }
}

function Get-ChildItemSize {
    # https://stackoverflow.com/questions/17466586/how-to-convert-a-size-variable-from-bytes-into-gb-in-powershell
    # https://stackoverflow.com/questions/24616806/powershell-display-files-size-as-kb-mb-or-gb?rq=3
    # la | Format-Table Mode, LastWriteTime, @{Label='Length'; Expression={3}}, Name
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)] [string[]] $LiteralPath,
        [switch] $Force,
        [switch] $HumanReadable
    )
    process {
        if ($LiteralPath.Count -eq 0) {
            $LiteralPath += $ExecutionContext.SessionState.Path.CurrentLocation
        }
        foreach ($path_item in $LiteralPath) {
            # check if path_item exists
            if (-not (Test-Path -LiteralPath $path_item)) {
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.InvalidOperationException] "Cannot find path '${path_item}' because it does not exist, or is not literal",
                    'InvalidPath',
                    [System.Management.Automation.ErrorCategory]::InvalidOperation,
                    $path_item
                )
                $PSCmdlet.WriteError($ErrorRecord)
                continue
            }
            $item = Get-Item -Force:$Force -LiteralPath $path_item
            # check if in a FileSystem drive
            if ($item.PSProvider.Name -ne 'FileSystem') {
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.InvalidOperationException] 'Not in a FileSytem drive',
                    'InvalidProvider',
                    [System.Management.Automation.ErrorCategory]::PermissionDenied,
                    $path_item
                )
                $PSCmdlet.WriteError($ErrorRecord)
                continue
            }
            # check if the item is a directory
            if (-not ($item.Mode -match 'd')) {
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.ArgumentException] "The path '${path_item}' is not a directory",
                    'NotDirectory',
                    [System.Management.Automation.ErrorCategory]::InvalidArgument,
                    $path_item
                )
                $PSCmdlet.WriteError($ErrorRecord)
                continue
            }
            Get-ChildItem -LiteralPath $item.FullName -Force:$Force | % {[PSCustomObject] @{
                Mode = $_.Mode
                LastWriteTime = $_.LastWriteTime
                Length = Get-ItemSize -LiteralPath $_.FullName -Force:$Force -HumanReadable:$HumanReadable
                Name = $_.Name
            }} | % {$_.PSObject.TypeNames.Insert(0, 'DirectorySizeInfo'); $PSCmdlet.WriteObject($_)}
        }
    }
}
function Alias-LAS {Get-ChildItemSize -Force -HumanReadable $args}
New-Item -Path Alias:las -Value Alias-LAS -Force > $null

# format for displaying DirectorySizeInfo objects like DirectoryInfo objects
# https://itblog.ldlnet.net/index.php/2020/04/22/powershell-how-to-create-a-custom-view-for-your-ps-output-objects/
Update-FormatData -AppendPath "${_powershell_dir}\utils\ItemSize.Format.ps1xml"

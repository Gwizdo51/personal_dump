param(
    # [string] $Venv = 'workenv',
    # [string] $RootDir = $code
    [string] $Venv,
    [string] $RootDir
)

Write-Host '$Venv:' $Venv
Write-Host '$RootDir:' $RootDir

if (!$Venv) {$Venv = Read-Host 'Select a virtual environment'}
if ($Venv -eq '') {$Venv = 'workenv'}
Write-Host 'Running in virtual environment:' $Venv
if (!$RootDir) {
    $RootDir_not_valid = $True
    while ($RootDir_not_valid) {
        $RootDir = Read-Host 'Select a root directory'
        if ($RootDir -eq '') {$RootDir = $code}
        if ((Test-Path $RootDir) -and ((type (Get-Item $RootDir)) -eq 'System.IO.DirectoryInfo'))
            {$RootDir_not_valid = $False}
    }
}
Write-Host 'Root directory:' $RootDir

cda -Venv $Venv
cd $RootDir
jupyter lab

# Write-Host "sleeping..."
# Start-Sleep 10

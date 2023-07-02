param(
    [string] $VEnv,
    [string] $RootDir,
    [switch] $SilentServer
)

try {. $profile -Silent} # process
catch {. $using:profile -Silent} # job

if (!$SilentServer) {
    $InformationPreference = 'Continue'
}

######################
### JUPYTER SERVER ###
######################
Write-Information "`n######################`n### JUPYTER SERVER ###`n######################`n"

# if $VEnv is not set, request user input
if (!$VEnv) {$VEnv = Read-Host 'Select a virtual environment'}
if ($VEnv -eq '') {$VEnv = 'workenv'}
Write-Information "Running in virtual environment: $VEnv"
# if $RootDir is not set, request user input
if (!$RootDir) {
    $RootDir_not_valid = $True
    while ($RootDir_not_valid) {
        $RootDir = Read-Host 'Select a root directory'
        if ($RootDir -eq '') {$RootDir = $code}
        if ((Test-Path $RootDir) -and ((type (Get-Item $RootDir)) -eq 'System.IO.DirectoryInfo'))
            {$RootDir_not_valid = $False}
    }
}
Write-Information "Root directory: $RootDir"

Write-Information "`nLaunching server ...`n"

cda -VEnv $VEnv
cd $RootDir
jupyter lab

# Write-Host "sleeping..."
# Start-Sleep 10

param(
    [string] $VEnv,
    [string] $RootDir
)

# load custom profile
try {. $profile -Silent} # process
catch {. $using:profile -Silent} # job

######################
### JUPYTER SERVER ###
######################
Write-Output "`n######################`n### JUPYTER SERVER ###`n######################`n"

# if $VEnv is not set, request user input
if (!$VEnv) {$VEnv = Read-Host 'Select a virtual environment'}
if ($VEnv -eq '') {$VEnv = $default_conda_venv}
Write-Output "Running in virtual environment: ${VEnv}"
# if $RootDir is not set, request user input
if (!$RootDir) {
    $RootDir_not_valid = $True
    while ($RootDir_not_valid) {
        $RootDir = Read-Host 'Select a root directory'
        if ($RootDir -eq '') {$RootDir = $default_dir}
        if ((Test-Path $RootDir) -and ((type (Get-Item $RootDir)) -eq 'System.IO.DirectoryInfo'))
            {$RootDir_not_valid = $False}
    }
}
Write-Output "Root directory: ${RootDir}"

Write-Output "`nLaunching server ...`n"

Conda-Activate -VEnv $VEnv
cd $RootDir
jupyter lab

# Write-Host "sleeping..."
# Start-Sleep 10

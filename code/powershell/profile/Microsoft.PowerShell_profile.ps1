param([switch]$Silent, [switch]$Verbose)

# environment config:

# - directories shortcuts
# delete and add as necessary
$code = 'D:\code'
$horoview = "${code}\projects\01_horoview"
# "$dump" must point to the root of this git repository
$dump = "${code}\personal_dump"

# - Git
# "$Env:GIT_EXE" must point to the git.exe executable
$Env:GIT_EXE = 'C:\Program Files\Git\cmd\git.exe'

# <#
# - Anaconda
# comment this block if anaconda isn't installed
# "$Env:_CONDA_ROOT" must point to the anaconda installation directory (anaconda3)
$Env:_CONDA_ROOT = 'C:\ProgramData\anaconda3'
# default conda venv (default is 'base')
$default_conda_venv = 'workenv'
#>


# run windows_custom_profile.ps1
$custom_profile = "${dump}\code\powershell\profile\windows_custom_profile.ps1"
. $custom_profile -Silent:$Silent -Verbose:$Verbose

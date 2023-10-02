param([switch]$Silent, [switch]$Verbose)

# environment config:

# - directories shortcuts
# delete and add as necessary
$code = 'D:\code'
$horoview = "${code}\projects\01_horoview"
# "$dump" must point to the root of this git repository
$dump = "${code}\personal_dump"

# <#
# - Anaconda
# comment this block if anaconda isn't installed
# "$Env:_CONDA_ROOT" must point to the anaconda installation directory (anaconda3)
$Env:_CONDA_ROOT = 'C:\ProgramData\anaconda3'
# default conda venv (default: 'base')
$default_conda_venv = 'workenv'
# default root directory for jupyter lab (default: $HOME)
$default_dir = $code
#>

# "$Env:GCC_EXE" must point to the 'gcc.exe' file in MinGW/bin
# comment this line if MinGW/bin is in the path or isn't installed
$Env:GCC_EXE = 'D:\Programs\MinGW\bin\gcc.exe'


# run windows_custom_profile.ps1
$custom_profile = "${dump}\code\powershell\profile\windows_custom_profile.ps1"
. $custom_profile -Silent:$Silent -Verbose:$Verbose

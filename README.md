# TODO list

### *WIP*
- [ ] add more verbose to profile
- [ ] add linux + bash notes

### *TODO*
- [ ] add powershell docstrings to own cmdlets
- [ ] mess with [PSReadLine](https://learn.microsoft.com/en-us/powershell/module/psreadline/?view=powershell-7.3)
- [ ] add tkinter tests
- [ ] make DotDict.\_\_dict__ behavior consistent with a regular object (not a dict) behavior
- [ ] make every DotDict dict method consistent with the dict class
- [ ] make pretty_string_factory a module on its own
- [ ] add a docstring to logger_factory.py and touch.py
- [ ] add unit tests for dotdict.py
- [ ] add django notes + test code
- [ ] add ssh notes
- [ ] add windows command prompt notes
- [ ] add a RegEx UUID detector to tests.py
- [ ] test python decorators
- [ ] add windows notes about adding virtual memory
- [ ] add git flow notes
- [ ] add keyboard shortcut to start screensaver on demand on windows
- [ ] create "Réussite" game
- [ ] reinstall OS at some point (never update conda on base with conda-forge, btw)
- [ ] add notes on connecting PS4 controller on windows

### *DONE*
- [x] add .gitattribute file
- [x] debug deleting nested items for DotDict
- [x] add docstrings to DotDict => make custom docstring template
- [x] store touch.py logic in a function
- [x] make a pretty PowerShell prompt (system)
- [x] debug PowerShell prompt git-branch part (branch name not updating)
- [x] make a pretty PowerShell prompt (7)
- [x] delete useless variables from the current scope after loading the profile
- [x] speed up PS profile load => call "conda-hook" only when conda is called the first time ?
- [x] add a mklink alias
- [x] add a shortcut to edit the user profile in VSCode
- [x] add a function that prints example strings with the available colors
- [x] don't color git prompt parentheses
- [x] test if .gitattributes is working as intended
- [x] add a mechanism to run the jupyter lab server on a seperate hidden powershell process
- [x] make a UNIX-style "sudo" alias
- [x] repair sudo when current directory is a drive root
- [x] make sudo scan ps_buffer for new lines to print while waiting for the process to finish
- [x] make sudo rewrite the last line written every second to account for updates
- [x] add work time script + docstrings
- [x] debug Kill-Jupyter when killing specific ports
- [x] convert jupyter_server_wrapper functions into cmdlets
- [x] add powershell notes
- [x] add jupyter JSON config files
- [x] add input file format checking to time_worked.py
- [x] convert custom PS functions into cmdlets
- [x] add a data folder to put jupyter lab logo and windows error sound
- [x] adapt ShouldProcess-Yes-No to write the whatif message as verbose
- [x] move all hardcoded paths to Microsoft.PowerShell_profile.ps1
- [x] make it possible to use the profile without conda
- [x] make Alias-Python prompt before activating conda
- [x] convert Touch-File into a cmdlet
- [x] add specific exception types to exceptions risen by cmdlets
- [x] adapt "-Force" switch behavior in jupyter_server_wrapper.ps1 to bypass all confirmation
- [x] make sudo run the command directly in the terminal if it has elevated privileges
- [x] make sudo always run in the version of powershell that called it
- [x] make an "Update" cmdlet (conda, git, terminal, powershell, powertoys)
- [x] convert "Get-Type" into a cmdlet
- [x] convert "GCC-Wrapper" into a cmdlet
- [x] add markdown (+ markdown viewer) notes
- [x] add C notes
- [x] debug conda prompt when using folder venv
- [x] make a "Restart-System" cmdlet
- [x] make a "Recycle" cmdlet
- [x] make a "Get-Size" cmdlet (must work with folders)

# Ideas

### *DotDict*
- add MappingProxyType support to DotDict ?
- make DotDict work with any type of key (convert keys to strings) ?
- make a script that returns whether a string can be used at all as a class attribute name ?

### *pretty_string_factory*
- make pretty_string_factory print the class name when it is not a builtin type ?

### *powershell profile*
- add a script to interact with the trashbin ?
    - restore a file from the recycle bin if it is unique, or maybe the last one
    - [empty it completely](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/clear-recyclebin?view=powershell-7.3)
    - open in file explorer
    - [good blog post](https://jdhitsolutions.com/blog/powershell/7024/managing-the-recycle-bin-with-powershell/)

### *Windows*
- add a scheduler task to start the task manager on session start ?

### *other*
- install WSL ?
- make a script to download all listed urls with youtube-dl

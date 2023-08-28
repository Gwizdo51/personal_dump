# TODO

### *Done*
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

### *WIP*
- [ ] debug Kill-Jupyter when killing specific ports
- [ ] convert jupyter_lab and sudo to cmdlets
- [ ] add windows registry notes
- [ ] add Recycle cmdlet
- [ ] override "del", "erase", "rm" and "rmdir" aliases (Remove-Item) to always ask for confirmation
- [ ] convert custom PS functions into aliases
- [ ] make a Get-Size cmdlet
- [ ] add powershell notes
- [ ] make DotDict.\_\_dict__ behavior consistent with a regular object (not a dict) behavior
- [ ] make every DotDict dict method consistent with the dict class

### *TODO*
- [ ] mess with [PSReadLine](https://learn.microsoft.com/en-us/powershell/module/psreadline/?view=powershell-7.3)
- [ ] make pretty_string_factory a module on its own
- [ ] add a docstring to logger_factory.py and touch.py
- [ ] add unit tests for dotdict.py
- [ ] add markdown notes
- [ ] add django notes
- [ ] add ssh notes
- [ ] add vscode and jupyter JSON config files
- [ ] reinstall OS at some point (never update conda on base with conda-forge, btw)

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

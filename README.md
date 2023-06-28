# personal_dump
A random clutter of stuff I should remember.

---

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
- [x] speed up PS profile load => call conda-hook the first time conda is activated ?

### *WIP*
- [ ] add a mklink alias
- [ ] add "send to trash" function ? => override "rm" alias
- [ ] convert custom PS functions into aliases
- [ ] add powershell notes
- [ ] make DotDict.\_\_dict__ behavior consistent with a regular object (not a dict) behavior
- [ ] make every DotDict dict method consistent with the dict class

### *TODO*
- [ ] test if .gitattributes is working as intended
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
- add notepad alias "np" ?
- touch alias with New-Item ?
- add a script to interact with the trashbin ?
    - restore a file from the recycle bin if it is unique, or maybe the last one
    - [empty it completely](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/clear-recyclebin?view=powershell-7.3)
    - open in file explorer
    - [good blog post](https://jdhitsolutions.com/blog/powershell/7024/managing-the-recycle-bin-with-powershell/)

### *Windows*
- add a scheduler task to start the task manager on session start ?

### *other*
- install WSL ?

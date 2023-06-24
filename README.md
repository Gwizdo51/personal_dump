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

### *WIP*
- [ ] make DotDict.\_\_dict__ behavior consistent with a regular object (not a dict) behavior
- [ ] make every DotDict dict method consistent with the dict class
- [ ] add a unix-style flag parser
- [ ] debug PowerShell prompt git-branch part (branch name not updating)
- [ ] make a pretty PowerShell prompt (7)
- [ ] convert custom functions into aliases

### *TODO*
- [ ] make pretty_string_factory a module on its own
- [ ] add a docstring to logger_factory.py and touch.py
- [ ] add unit tests for dotdict.py
- [ ] add markdown notes
- [ ] add django notes
- [ ] reinstall OS at some point (never update conda on base with conda-forge, btw)

# Ideas

*DotDict*
- add MappingProxyType support to DotDict ?
- make DotDict work with any type of key (convert keys to strings) ?
- make a script that returns whether a string can be used at all as a class attribute name ?

*pretty_string_factory*
- make pretty_string_factory print the class name when it is not a builtin type ?

*powershell profile*
- add notepad alias "np" ?
- touch alias with New-Item ?
- add "send to trash" function ? => override "rm" alias
- update conda alias ?

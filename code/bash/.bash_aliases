alias up1='sudo apt-get update'
alias up2='sudo apt-get upgrade'
alias up3='sudo apt-get dist-upgrade'
alias sysupdate='up1 && up2 && up3'

alias clean1='sudo apt-get autoclean'
alias clean2='sudo apt-get clean'
alias clean3='sudo apt-get autoremove'
alias sysclean='clean2 && clean3'

alias la='ls -A1F --group-directories-first'
alias la2='ls -AF --group-directories-first'		# same but not 1 line per item
alias ll='ls  -lAF --group-directories-first'		# all details
alias lr='ls -ARF --group-directories-first'		# list contents of subfolders
alias las="bash ~/my_bash_scripts/cwdsize.sh"		# get size of items
alias nanow='nano -lL'
alias nanor='nano -lvL'

alias del='rm -i'
alias deldir='rm -ri'
alias rmd='rm -r'

alias cpd='cp -r'

#alias slm='bash /home/arthur/my_bash_scripts/launch_system_load_monitor.sh'
alias slm='ps -C "indicator-multi" >/dev/null && echo "System load monitor is already running." || bash /home/arthur/my_bash_scripts/launch_system_load_monitor.sh'

alias lamp='bash /home/arthur/my_bash_scripts/launch_lampstack_manager.sh'

alias cda='conda activate workenv'
alias cdd='conda deactivate'
alias cdupdate='conda update -n workenv --all'

# for git :
alias git_tree="git log --oneline --decorate --all --graph"

# jupyter notebook in projects
alias jupyter_projects="cda && cd /media/arthur/DATA/Code/projects && jupyter lab"
alias jupyter_code="cda && cd /media/arthur/DATA/Code && jupyter lab"

# django manage.py shortcut
alias django="python manage.py"
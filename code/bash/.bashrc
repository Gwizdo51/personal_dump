# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi

unset color_prompt force_color_prompt

##################
### CUSTOM PS1 ###
##################

# Define color variables
RESET="\[\033[00m\]"
BOLD="\[\033[1m\]"
DIM="\[\033[2m\]"
UNDERLINE="\[\033[4m\]"

FG_RED="\[\033[31m\]"
FG_GREEN="\[\033[32m\]"
FG_YELLOW="\[\033[33m\]"
FG_BLUE="\[\033[34m\]"
FG_MAGENTA="\[\033[35m\]"
FG_CYAN="\[\033[36m\]"
FG_WHITE="\[\033[37m\]"

gen_prompt() {
    local prompt="${debian_chroot:+($debian_chroot)}${FG_GREEN}${BOLD}\u@\h${RESET}:${FG_BLUE}${BOLD}\w${RESET}"
    if git rev-parse --is-inside-work-tree &> /dev/null; then
        local branch="$(git rev-parse --abbrev-ref HEAD)"
        if [ "${branch}" = 'HEAD' ]; then
            branch="${FG_RED}$(git rev-parse --short HEAD)"
        else
            branch="${FG_CYAN}${branch}"
        fi
        prompt="${prompt} (${BOLD}${branch}${RESET})"
    fi
    prompt="${prompt}\n${BOLD}${FG_YELLOW}\$${RESET} "
    echo -e "${prompt}"
}
PROMPT_COMMAND='PS1="$(gen_prompt)"'

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# add the ~/bin/ dir to the PATH if it exists
if [ -d "$HOME/bin" ]; then
    PATH="${PATH}:$HOME/bin"
fi

# https://unix.stackexchange.com/a/438712
function Sudo {
    local firstArg=$1
    if [ $(type -t $firstArg) = function ]
    then
        shift && command sudo bash -c "$(declare -f $firstArg);$firstArg $*"
    elif [ $(type -t $firstArg) = alias ]
    then
        alias sudo='\sudo '
        eval "sudo $@"
    else
        command sudo "$@"
    fi
}

# ps -ef | grep sshd | grep -v -e grep -e root | awk '{print "sudo kill -TERM", $2}' | sh
# function shutdown_user_sessions() {
#     if [ "$(whoami)" != 'root' ]; then
#         echo 'The "restart" command must be run as root'
#         return 1
#     fi
#     # Get list of currently logged-in users (excluding root and system users)
#     # 'who -u' shows idle time, etc.
#     # 'awk' to extract just the username
#     local users=$(who | awk '{print $1}')
#     local user
#     for user in $users; do
#         # SIGTERM to gracefully exit
#         pkill -TERM -u "$user"
#     done
#     # Give processes a moment to gracefully exit (e.g., 5 seconds)
#     sleep 5
#     # Check for any remaining processes and forcefully kill them if needed
#     local remaining_users=$(who | awk '{print $1}')
#     for user in $remaining_users; do
#         # SIGKILL to force kill
#         pkill -KILL -u "$user"
#     done
# }

# if [ "$(whoami)" != 'root' ]; then echo 'prout'; fi

# test_am_i_root() {
#     if [ "$(whoami)" != 'root' ]; then
#         echo 'I am not root'
#     else
#         echo 'I am root'
#     fi
# }

restart() {
    if [ "$(whoami)" != 'root' ]; then
        echo 'The "restart" command must be run as root'
        return 1
    fi
    # start a job : wait 1 seconds, then restart the computer
    sleep 1 && shutdown -r now &
    # kill all SSH sessions
    ps -ef | grep sshd | grep -v -e grep -e root | awk '{print "kill -TERM", $2}' | sh
}
# kill all SSH connections and restart the computer after 1 seconds :
# Sudo restart

turnoff() {
    if [ "$(whoami)" != 'root' ]; then
        echo 'The "turnoff" command must be run as root'
        return 1
    fi
    # start a job : wait 1 seconds, then shutdown the computer
    sleep 1 && shutdown -P now &
    # kill all SSH sessions
    ps -ef | grep sshd | grep -v -e grep -e root | awk '{print "kill -TERM", $2}' | sh
}
# kill all SSH connections and shutdown the computer after 1 seconds :
# Sudo turnoff

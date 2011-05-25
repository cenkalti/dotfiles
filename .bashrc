# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

umask 022

export EDITOR="emacs"
export LESS="-R"

export PS1="\[\033]0;${USER}@${HOSTNAME}\007\]"  ##display user@host in titlebar or "%h" screen string escape
export PS1=${PS1}'\[\033k\033\\\]'  ##display running command for window name in screen's caption line
#export PS1=${PS1}'\[\033k'${HOSTNAME}'\033\\\]'  ##show hostname for window name on screen's caption line when idle
export PS1='\w '${PS1}'\$ '

# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set bash promt
PS1='\h:\w\[\033[01;32m\]\$\[\033[00m\] '

# If this is an xterm set the title
case "$TERM" in
xterm*|rxvt*|screen*)
    PS1="\[\033]0;\h\007\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR=emacs

# append ~/bin to PATH
if [ -d ~/bin ]; then
    export PATH=~/bin:$PATH
fi

if [ -d /usr/local/sbin ]; then
    PATH=$PATH:/usr/local/sbin
fi

# list running tmux sessions
if [ -z "$TMUX" ] && [ -f /usr/bin/tmux ]; then
    if [[ `tmux ls 2>/dev/null | wc -l` != "0" ]]; then
	tmux ls
    fi
fi

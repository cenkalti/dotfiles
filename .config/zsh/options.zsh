# Shell options, history, keymap, keybindings.

# Use emacs keymap (^A, ^E, ^W, alt-backspace, ...).
bindkey -e

autoload -U select-word-style
select-word-style bash

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY

setopt interactivecomments  # recognize comments

# Do not change directory without "cd" command
unsetopt AUTO_CD

# ls colors
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# press ctrl-x then e to edit current command in editor
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

zmodload zsh/terminfo
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

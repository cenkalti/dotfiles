#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "cannot open '$1'" ;;
      esac
  else
      echo "invalid file '$1'"
  fi
}

umask 077

export EDITOR="emacs"
export LESS="-R"

# update pacman mirror list with 5 fastest mirrors and sort them based on rating
alias reflector='sudo mv /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist && sudo reflector -l 5 --sort rate --save /etc/pacman.d/mirrorlist'

# remove packages from system which are no longer in sync database
alias orphans='pacman -Qqdt | xargs -p sudo pacman -Rsn --noconfirm'

alias more='less'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -c -h'
alias ping='ping -c 1'
alias ..='cd ..'

# ls
alias ls='ls -F --color=always'
alias lr='ls -R'                    # recursive ls
alias ll='ls -lh'
alias la='ll -Ah'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

PS1='[\u@\h \W]\$ '

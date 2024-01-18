# zsh will read commands in order from:
#
# $ZDOTDIR/.zshenv    # sourced in all invocations
# $ZDOTDIR/.zprofile  # sourced in login shells, before zshrc
# $ZDOTDIR/.zshrc     # sourced in interactive shells
# $ZDOTDIR/.zlogin    # sourced in login shells, after zshrc
# $ZDOTDIR/.zlogout   # sourced in login shells, on logout
#
# See http://zsh.sourceforge.net/Intro/intro_3.html

autoload -U select-word-style
select-word-style bash

export EDITOR=nvim
export PAGER=less
export LESS="-iR"  # ignore case
export FZF_DEFAULT_COMMAND='fd --type f'

# Customize prompt
function virtualenv_info {
  if [ -n "$VIRTUAL_ENV" ]; then
    venv=$(basename $VIRTUAL_ENV)
    echo "($venv)"
  fi
}
function git_info {
  head=$(git symbolic-ref HEAD 2>/dev/null)
  if [ -n "$head" ]; then
    ref=$(echo $head | cut -d '/' -f 3-)
    echo "{$ref}"
  fi
}
setopt promptsubst
PROMPT='[%3>>%m%>>:%1~]$(virtualenv_info)$(git_info)%(?.%F{green}.%F{red})%#%f '

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY

# Fix backspace and delete keys
bindkey '^?' backward-delete-char  # [Backspace] - delete backward
bindkey "\e[3~" delete-char  # [Delete] - delete forward

setopt interactivecomments  # recognize comments

# ls colors
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'

# Aliases for easy navigation
alias l="ls -l"
alias la="ls -la"
alias lt="ls -lt | head"
alias lg="lazygit"
alias d="pwd"
alias u="sudo -iu"
alias s="sudo su"
alias e="etcdctl"
alias k="kubectl"
alias p="ptpython"
alias h="hostname"

# mmap is faster than read
alias ag="ag --mmap"

alias myip="curl http://ipinfo.io/ip"
alias mycity="curl http://ipinfo.io/city"

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias disk-usage='sudo du -xcms * 2>/dev/null | sort -rn | head -11'

alias remove-old-files="find . -mindepth 1 -maxdepth 1 -mtime +1 -exec rm -rf '{}' +"

alias https='http --default-scheme=https'

alias vu='vagrant up && vagrant ssh'
alias vs='vagrant suspend && exit'

alias cloc='cloc --exclude-dir vendor'

alias todo="ag TODO | tr '\t' ' ' | tr -s ' ' | grep --color TODO"

alias nvims="nvim -S Session.vim"

alias isodate='date +"%Y-%m-%dT%H:%M:%S%z"'

# Enable core dump
alias encoredump='ulimit -c unlimited'
# Disable core dump
alias nocoredump='ulimit -c 0'
# Check core dump
alias iscoredump='ulimit -c'

# Do not change directory without "cd" command
unsetopt AUTO_CD

# my ssh & tmux helper
function ssht() { ssh -t $1 "tmux attach -t $USER || tmux new -s $USER" }
function mt() { mosh $1 -- sh -c "tmux attach -t $USER || tmux new -s $USER" }
function home() { ssht "arch.home.cenkalti.com" }

function searchandreplace() {
    LC_ALL=C find $1 -path './.*' -prune -o -type f -name "*.$2" -exec sed -E -i '' "s/$3/$4/g" {} +
}

function searchanddelete() {
    LC_ALL=C find $1 -path './.*' -prune -o -type f -name "*.$2" -exec sed -E -i '' "/$3/d" {} +
}

function loop() {
    seconds="$1"; shift
    while true; do
        echo "\$ $@"
        $@
        sleep $seconds
    done
}

function run-until-error() { while $@; do :; done; say "command is finished" }

function monitor() { watch -n 1 "pgrep -l ${@:q} | grep -v watch" }
function monitor-full() { watch -n 1 "pgrep -a ${@:q} | grep -v watch" }

function etime() { ps -eo pid,comm,etime,args | grep $1 }

# iTerm2 badge. https://iterm2.com/documentation-badges.html
function badge { printf "\e]1337;SetBadgeFormat=$(echo "$@" | base64)\a"  }

# Git Push Tag helper
# https://stackoverflow.com/questions/3760086/automatic-tagging-of-releases
function gpt() {
  # get bump level
  level="$1"; shift

  # get highest tag number
  version=$(git describe --abbrev=0 --tags | tr -d v)

  # split from dots
  parts=(${(s:.:)version})

  #get number parts and increase last one by 1
  VNUM1=${parts[1]}
  VNUM2=${parts[2]}
  VNUM3=${parts[3]}

  case "$level" in
    "major")
      VNUM1=$((VNUM1+1))
      VNUM2=0
      VNUM3=0
      ;;
    "minor")
      VNUM2=$((VNUM2+1))
      VNUM3=0
      ;;
    "patch")
      VNUM3=$((VNUM3+1))
      ;;
    *)
      echo "Missing argument. (major, minor or patch)"
      return -1
  esac

  #create new tag
  new_tag="v$VNUM1.$VNUM2.$VNUM3"

  read \?"Press enter for tagging as $new_tag and push to remote..."

  git tag $new_tag
  git push --tags
}

# git aliases
alias g="git st"
alias gp="git push || git pull --rebase && git push"
alias gti=git
# ...others are in .gitconfig file

# shows listening ports
alias listening="sudo lsof -Pn -iTCP -sTCP:LISTEN"

# pacman
alias pacu='sudo pacman -Syu'       # Update the system and upgrade all system packages.
alias paci='sudo pacman -S'         # Install a specific package from repos added to the system
alias pacl='sudo pacman -U'         # Install specific package that has been downloaded to the local system
alias paci='pacman -Si'             # Display information about a given package located in the repositories
alias pacs='pacman -Ss'             # Search for package or packages in the repositories
alias pacr='sudo pacman -R'         # Remove the specified package but retain its configuration and deps
alias pacrall='sudo pacman -Rns'    # Remove package, its configuration and all unwanted dependencies
alias pacsl='pacman -Qi'            # Display information about a given package in the local database
alias paclocs='pacman -Qs'          # Search for package/packages in the local database

# yay
alias yu='yay -Syua'        # Synchronize with repositories and upgrade packages, including AUR packages.
alias yi='yay -S'           # Install a specific package from repos added to the system
alias yil='yay -U'          # Install specific package that has been downloaded to the local system
alias yr='yay -R'           # Remove package but retain configs and required dependencies
alias yrall='yay -Rns'      # Remove package or packages , its configuration and all unwanted dependencies
alias yip='yay -Si'         # Display information about a given package located in the repositories
alias ys='yay -Ss'          # Search for package or packages in the repositories
alias yil='yay -Qi'         # Display information about a given package in the local database
alias ysl='yay -Qs'         # Search for package(s) in the local database
alias yll='yay -Qe'         # List installed packages, even those installed from AUR (they're tagged as "local")
alias yro='yay -Qtd'        # Remove orphans using yay

# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks
alias pacman-remove-orphans="pacman -Qtdq | sudo pacman -Rns -"
function pacman-leaves() {
  expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqen | sort) <({ expac -l '\n' '%E' base; } | sort -u)) | sort -n
}

# docker aliases
alias docker-remove-all-containers="docker ps -aq | xargs docker rm --force"
alias docker-remove-stopped-containers="docker ps -aq -f status=exited -f status=created | xargs docker rm --force"
alias docker-remove-dangling-images="docker images -qf dangling=true | xargs docker rmi"
alias docker-remove-dangling-volumes="docker volume ls -qf dangling=true | xargs docker volume rm"
alias docker-clean="docker-remove-stopped-containers && docker-remove-dangling-volumes && docker-remove-dangling-images"
alias dme='eval $(docker-machine env default)'
function docker-remove-images-pattern() {
  docker images | grep "$1" | awk '{print $1":"$2}' | xargs docker rmi
}
function docker-remove-container-pattern() {
  docker ps -a | grep "$1" | awk '{print $1}' | xargs docker rm
}
function docker-build-and-run() {
  name="$(basename $(pwd))"
  docker build -t $name . && docker run -it --rm --name $name $name $@
}
function dex {
  docker exec -it $1 ${2:-bash}
}
function dl {
  docker logs -f $1
}

# go aliases
alias gi="go install"
alias gr="go run *.go"
# show imported packages in go
alias go-list-imports="go list -f '{{join .Deps \"\n\"}}' | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}'"

alias github-remove-draft-releases="hub release -f '%T (%S) %n' --include-drafts | grep ' (draft)' | awk '{print $1}' | xargs -t -n1 hub release delete"

# press ctrl-x then e to edit current command in editor
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

# enable completion subsystem
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

type kubectl &>/dev/null && source <(kubectl completion zsh)
type aws &>/dev/null && type aws_completer &>/dev/null && complete -C aws_completer aws

# colorize man pages
function man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

zmodload zsh/terminfo
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

function set_title {
  emulate -L zsh
  setopt prompt_subst
  local tab_name=$1
  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      print -Pn "\e]0;$tab_name:q\a"
      ;;
  esac
}

# Runs before showing the prompt
function precmd {
  emulate -L zsh
  set_title "%m:%1~"
}

# Runs before executing the command
function preexec {
  emulate -L zsh
  setopt extended_glob

    # cmd name only, or if this is sudo or ssh, the next cmd
    local CMD=${1[(wr)^(*=*|sudo|ssh|ssht|mosh|mt|-*)]:gs/%/%%}

    case "$CMD" in
      # show current dir on tab when vim is open
      vi*)
        ;&
      nvim*)
        CMD="$CMD (%1~)"
        ;;
      # show current host when tmux is open
      tmux*)
        CMD="%m"
        ;;
    esac

  set_title '$CMD'
}

precmd_functions+=(precmd)
preexec_functions+=(preexec)

if [[ -f ~/.zshrc_private ]]; then
  source ~/.zshrc_private
fi

n ()
{
    # Block nesting of nnn in subshells
    if [[ "${NNNLVL:-0}" -ge 1 ]]; then
        echo "nnn is already running"
        return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The backslash allows one to alias n to nnn if desired without making an
    # infinitely recursive alias
    \nnn -A "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

GPG_TTY=$(tty)
export GPG_TTY

if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
if [ -f "/usr/share/doc/pkgfile/command-not-found.zsh" ]; then
  source "/usr/share/doc/pkgfile/command-not-found.zsh"
fi

export AWS_PAGER=""

export JSII_DEPRECATED="quiet"

# Shell-GPT integration ZSH v0.1
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd")
    zle end-of-line
fi
}
zle -N _sgpt_zsh
bindkey '^[\' _sgpt_zsh  # Alt-\
# Shell-GPT integration ZSH v0.1

################################################################################
# Anything added after this line must go into .zprofile or .zshrc_private file.
################################################################################

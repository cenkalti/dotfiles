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

export EDITOR=vim
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
    ref=$(echo $head | cut -d '/' -f 3)
    echo "{$ref}"
  fi
}
setopt promptsubst
PROMPT='[%3>>%m%>>:%1~]$(virtualenv_info)$(git_info)%(?.%F{green}.%F{red})%#%f '

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
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
alias d="pwd"
alias u="sudo -iu"
alias s="sudo su"

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

alias todo="ag TODO | tr -d '\t' | sed -e 's/\/\///' | grep --color TODO"

alias nvims="nvim -S Session.vim"

# Do not change directory without "cd" command
unsetopt AUTO_CD

# my ssh & tmux helper
function ssht() { ssh -t $1 "tmux attach -t $USER || tmux new -s $USER" }
function mt() { mosh $1 -- sh -c "tmux attach -t $USER || tmux new -s $USER" }

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

function monitor() { watch -n 1 "pgrep -fa $@ | grep -v watch" }

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

# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

# git aliases
alias g="git st"
alias gp="git push || git pull --rebase && git push"
alias gti=git
# ...others are in .gitconfig file

# shows listening ports
alias listening="sudo lsof -Pn -iTCP -sTCP:LISTEN"

# '[r]emove [o]rphans' - recursively remove ALL orphaned packages
alias pacman-remove-orphan="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rns \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;\$!ba;s/\n/ /g')"

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
  local window_name=$2

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      print -Pn "\e]1;$tab_name:q\a"
      print -Pn "\e]2;$window_name:q\a"
      ;;
    screen*)
      print -Pn "\ek$tab_name:q\e\\" # set screen hardstatus
      ;;
  esac
}

# Runs before showing the prompt
function precmd {
  emulate -L zsh
  set_title "%m:%1~" "%m:%~"
}

# Runs before executing the command
function preexec {
  emulate -L zsh
  setopt extended_glob

  # Get the command name that is under job control.
  if [[ "${2[(w)1]}" == (fg|%*)(\;|) ]]; then
    # Get the job name, and, if missing, set it to the default %+.
    local job_name="${${2[(wr)%*(\;|)]}:-%+}"

    # Make a local copy for use in the subshell.
    local -A jobtexts_from_parent_shell
    jobtexts_from_parent_shell=(${(kv)jobtexts})

    jobs "$job_name" 2>/dev/null > >(
      read index discarded
      # The index is already surrounded by brackets: [1].
      preexec "${(e):-\$jobtexts_from_parent_shell$index}"
    )
  else
    # cmd name only, or if this is sudo or ssh, the next cmd
    local CMD=${1[(wr)^(*=*|sudo|ssh|ssht|mosh|mt|-*)]:gs/%/%%}

    # show current dir on tab when vim is open
    if [[ $CMD == vi* ]]; then
      CMD="$CMD (%m:%1~)"
    fi
    if [[ $CMD == nvim* ]]; then
      CMD="$CMD (%m:%1~)"
    fi

    set_title '$CMD'
  fi
}

precmd_functions+=(precmd)
preexec_functions+=(preexec)

if [[ -f ~/.zshrc_private ]]; then
  source ~/.zshrc_private
fi

################################################################################
# Anything added after this line must go into .zprofile or .zshrc_private file.
################################################################################

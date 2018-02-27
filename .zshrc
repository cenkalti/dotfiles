# zsh will read commands in order from:
#
# $ZDOTDIR/.zshenv
# $ZDOTDIR/.zprofile
# $ZDOTDIR/.zshrc
# $ZDOTDIR/.zlogin
# $ZDOTDIR/.zlogout
#
# See http://zsh.sourceforge.net/Intro/intro_3.html

autoload -U select-word-style
select-word-style bash

export EDITOR=vim
export PAGER=less
export LESS="-i"  # ignore case

# use emacs key bindings
bindkey -e

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
PROMPT='[%m:%1~]$(virtualenv_info)$(git_info)%(?.%F{green}.%F{red})%#%f '

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
alias d="pwd"
alias u="sudo -iu"

alias p="ptpython"
alias h="hostname"

alias myip="curl http://ipecho.net/plain && echo"

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias disk-usage='sudo du -xcms * 2>/dev/null | sort -rn | head -11'

alias remove-old-files="find . -mindepth 1 -maxdepth 1 -mtime +1 -exec rm -rf '{}' +"

alias https='http --default-scheme=https'

# Do not change directory without "cd" command
unsetopt AUTO_CD

# my ssh & tmux helper
function ssht() { ssh -t $1 "tmux attach -t $USER || tmux new -s $USER" }

function searchandreplace() {
    LC_ALL=C find $1 -path './.*' -prune -o -type f -name "*.$2" -exec sed -E -i '' "s/$3/$4/g" {} +
}

function searchanddelete() {
    LC_ALL=C find $1 -path './.*' -prune -o -type f -name "*.$2" -exec sed -E -i '' "/$3/d" {} +
}

# completion settings
autoload -U compinit bashcompinit
compinit
bashcompinit

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
alias docker-clean-containers="docker ps -aq -f status=exited -f status=created | xargs docker rm --force"
alias docker-remove-dangling-images="docker images -qf dangling=true | xargs docker rmi"
alias docker-remove-dangling-volumes="docker volume ls -qf dangling=true | xargs docker volume rm"
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

# taskwarrior
alias t="task"
alias in='task add +in'
alias put='task add +putio'
function tc() { task $1 modify -in +$2 priority:$3 }

# nosecomplete
function _nosetests() {
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=(`nosecomplete ${cur} 2>/dev/null`)
}
complete -o nospace -F _nosetests nosetests

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
bindkey -M emacs '^P' history-beginning-search-backward
bindkey -M emacs '^N' history-beginning-search-forward

if [[ -f ~/.zshrc_private ]]; then
  source ~/.zshrc_private
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
    local CMD=${1[(wr)^(*=*|sudo|ssh|ssht|mosh|-*)]:gs/%/%%}

    # show current dir on tab when vim is open
    if [[ $CMD == vi* ]]; then
      CMD="$CMD (%m:%1~)"
    fi

    set_title '$CMD'
  fi
}

precmd_functions+=(precmd)
preexec_functions+=(preexec)

# added by travis gem
[ -f /Users/cenk/.travis/travis.sh ] && source /Users/cenk/.travis/travis.sh

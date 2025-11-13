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

alias l="eza -l --icons --git --hyperlink"
alias la="l -aa"
alias lt="ls -lt | head"

alias rg='rg --hyperlink-format=kitty'

# One-key shortcuts
alias d="pwd"
alias u="sudo -iu"
alias s="sudo su"
alias e="etcdctl"
alias k="kubectl"
alias p="ptpython"
alias h="hostname"

alias lg="lazygit"
alias lgd="lg --git-dir ~/.dotfiles --work-tree ~"

alias cl="claude"

alias myip="curl http://ipinfo.io/ip"
alias mycity="curl http://ipinfo.io/city"

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias disk-usage='sudo du -xcms * 2>/dev/null | sort -rn | head -11'

alias remove-old-files="find . -mindepth 1 -maxdepth 1 -mtime +1 -exec rm -rf '{}' +"

alias https='http --default-scheme=https'

function todo() {rg --line-number TODO | tr '\t' ' ' | tr -s ' ' | sort | awk -F':' '{print $3 " " "\033[34m" "!!!(" $1 ":" $2 ")" "\033[0m"}' | sed 's/.*TODO //' | awk '{print "\033[33mTODO\033[0m " $0}' | column -t -s'!!!'}
alias todow="watch --color -x zsh -ic 'todo | tee >(wc -l | xargs echo \"Count:\")'"

alias nvims="nvim -S Session.vim"

alias isodate='date +"%Y-%m-%dT%H:%M:%S%z"'

# Enable core dump
alias encoredump='ulimit -c unlimited'
# Disable core dump
alias nocoredump='ulimit -c 0'
# Check core dump
alias iscoredump='ulimit -c'

# my ssh & tmux helper
function ssht() { ssh -t $1 "tmux attach -t cenk || tmux new -s cenk" }
function mt() { mosh $1 -- sh -c "tmux attach -t cenk || tmux new -s cenk" }
function home() { mt "arch.home.cenkalti.com" }

function tunnel() { ssh -N -R "172.17.0.1:8080:127.0.0.1:$1" "cenk@arch.home.cenkalti.com" & }

function mkcd () {
  mkdir -p "$1"
  cd "$1"
}

function tempe () {
  cd "$(mktemp -d)"
  chmod -R 0700 .
  if [[ $# -eq 1 ]]; then
    mkdir -p "$1"
    cd "$1"
    chmod -R 0700 .
  fi
}

function searchandreplace() {
  if [ -z "$1" ]; then
    echo "Usage: searchandreplace <dir> <ext> <search> <replace>"
    return
  fi
  LC_ALL=C find $1 -path './.*' -prune -o -type f -name "*.$2" -exec sed -E -i '' "s/$3/$4/g" {} +
}

function searchanddelete() {
  if [ -z "$1" ]; then
    echo "Usage: searchandreplace <dir> <ext> <search>"
    return
  fi
  LC_ALL=C find $1 -path './.*' -prune -o -type f -name "*.$2" -exec sed -E -i '' "/$3/d" {} +
}

function loop() {
    seconds="$1"; shift
    while true; do
        echo "\$ $@"
        zsh -ic $@
        sleep $seconds
    done
}

function run-until-error() { while $@; do :; done; say "command is finished" }

function monitor()      { watch -n 1 "pgrep -l ${@:q} | grep -v watch" }
function monitor-full() { watch -n 1 "pgrep -a ${@:q} | grep -v watch" }

function etime() { ps -eo pid,comm,etime,args | grep $1 }

# Git Push Tag helper
function gpt() {
  # Get bump level and optional remote
  level="$1"
  remote="${2:-origin}"

  # Validate level argument
  case "$level" in
    "major"|"minor"|"patch") ;;
    *)
      echo "Usage: gpt <major|minor|patch> [remote]"
      return 1
  esac

  # Get highest tag and increment version
  version=$(git describe --abbrev=0 --tags 2>/dev/null | tr -d v || echo "0.0.0")
  parts=(${(s:.:)version})

  # Ensure we have 3 parts
  VNUM1=${parts[1]:-0}
  VNUM2=${parts[2]:-0}
  VNUM3=${parts[3]:-0}

  # Increment based on level
  case "$level" in
    "major") VNUM1=$((VNUM1+1)); VNUM2=0; VNUM3=0 ;;
    "minor") VNUM2=$((VNUM2+1)); VNUM3=0 ;;
    "patch") VNUM3=$((VNUM3+1)) ;;
  esac

  # Create new tag
  new_tag="v$VNUM1.$VNUM2.$VNUM3"

  read \?"Press enter for tagging as $new_tag and push to $remote..."

  git tag $new_tag
  git push "$remote" "$new_tag"
}

# git aliases
alias g="git st"
alias gp="git push || git pull --rebase && git push"
alias gti=git
# ...others are in .gitconfig file

# shows listening ports
alias listening="sudo lsof -Pn -iTCP -sTCP:LISTEN"

# pacman
alias paci='sudo pacman -S'         # Install a specific package from repos added to the system
alias pacr='sudo pacman -R'         # Remove the specified package but retain its configuration and deps
alias pacu='sudo pacman -Syu'       # Update the system and upgrade all system packages.
alias pacinf='pacman -Si'           # Display information about a given package located in the repositories
alias pacl='sudo pacman -U'         # Install specific package that has been downloaded to the local system
alias pacs='pacman -Ss'             # Search for package or packages in the repositories
alias pacrall='sudo pacman -Rns'    # Remove package, its configuration and all unwanted dependencies
alias pacsl='pacman -Qi'            # Display information about a given package in the local database
alias paclocs='pacman -Qs'          # Search for package/packages in the local database

# yay
alias yi='yay -S'           # Install a specific package from repos added to the system
alias yr='yay -R'           # Remove package but retain configs and required dependencies
alias yu='yay -Syua'        # Synchronize with repositories and upgrade packages, including AUR packages.
alias yil='yay -U'          # Install specific package that has been downloaded to the local system
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
alias dcu='docker compose up --detach --remove-orphans'
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
  docker exec -it "$1" "${@:2}"
}
function dl {
  docker logs -f $1
}

# go aliases
alias gr="go run *.go"
# show imported packages in go
alias go-list-imports="go list -f '{{join .Deps \"\n\"}}' | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}'"

alias noled="while true; do sudo smc -k ACLC -w 01; sleep 0.5; done"  # turn off magsafe charger led

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
      # These are OSC control sequences.
      # Terminals that support these sequences will change the title.
      # If you are using tmux, it will change the title of the pane.
      # For setting the window title in tmux, configure in your tmux.conf.
      print -Pn "\e]0;$tab_name:q\a"
      ;;
  esac
}

# Runs before showing the prompt
function precmd {
  emulate -L zsh
  set_title "%1~"
}

# Runs before executing the command
function preexec {
    local cmd="$1"

    # List of prefixes to strip
    prefixes=(
        "sudo"
        "ssh"
        "ssht"
        "mosh"
        "mt"
        "poetry run"
        "pdm run"
        "uv run"
        "python -m"
        "python3 -m"
    )

    for prefix in "${prefixes[@]}"; do
        # Check if command starts with the prefix
        if [[ "$1" = "$prefix"* ]]; then
            # Remove prefix and any leading whitespace
            cmd="${1#$prefix}"
            cmd="${cmd#"${cmd%%[![:space:]]*}"}"
            break
        fi
    done

    # Get only the first word
    cmd="${cmd%% *}"

    set_title "$cmd"
}

precmd_functions+=(precmd)
preexec_functions+=(preexec)

if [[ -f ~/.local.zshrc ]]; then
  source ~/.local.zshrc
fi

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function ghsetup() {
    # Check if a repository is provided
    if [ -z "$1" ]; then
        echo "Please provide a repository in the format username/project"
        return 1
    fi

    # Extract username and project name
    USERNAME=$(echo $1 | cut -d "/" -f1)
    PROJECT=$(echo $1 | cut -d "/" -f2)

    # Default to Python 3 if not provided
    PYTHON_VERSION=${2:-3}

    # Clone the repository
    git clone "https://github.com/$1.git" ~/projects/$PROJECT
    cd ~/projects/$PROJECT

    # Set up Python virtual environment
    python${PYTHON_VERSION} -m venv .venv
    echo layout venv .venv > .envrc
    direnv allow .

    # Determine if it's a pip or poetry project and install requirements
    if [ -f "uv.lock" ]; then
        echo "uv.lock detected"
        direnv exec . uv sync
    elif [ -f "pdm.lock" ]; then
        echo "pdm.lock detected"
        direnv exec . pdm install
    elif [ -f "poetry.lock" ]; then
        echo "poetry.lock detected"
        direnv exec . poetry install
    elif [ -f "pyproject.toml" ]; then
        echo "pyproject.toml detected"
        direnv exec . pip install build
        direnv exec . pip install .
    elif [ -f "requirements.txt" ]; then
        echo "requirements.txt detected"
        direnv exec . pip install -r requirements.txt
    else
        echo "No requirements file found. Skipping package installation."
    fi

    echo "Setup complete for $PROJECT"
}

function ghnvim() {
    ghsetup $@
    exec nvim -c NvimTreeOpen -c "Telescope git_files"
}

GPG_TTY=$(tty)
export GPG_TTY

if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey '^[l' autosuggest-accept
elif [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey '^[l' autosuggest-accept
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
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"
export K9S_CONFIG_DIR="$HOME/.config/k9s"

export CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1

# Shell-GPT integration ZSH v0.2
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    print -s "$_sgpt_prev_cmd"
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
    zle end-of-line
fi
}
zle -N _sgpt_zsh
bindkey '^[\' _sgpt_zsh  # Alt-\

if [ -f "/opt/homebrew/opt/spaceship/spaceship.zsh" ]; then
  source "/opt/homebrew/opt/spaceship/spaceship.zsh"
fi
if [ -f "/usr/lib/spaceship-prompt/spaceship.zsh" ]; then
  source "/usr/lib/spaceship-prompt/spaceship.zsh"
fi

# Load project specific aliases, etc.
autoload -U add-zsh-hook
load-local-aliases() {
  if [[ -f aliases.sh && -r aliases.sh ]]; then
    source aliases.sh
  fi
}
add-zsh-hook precmd load-local-aliases

################################################################################
# Anything added after this line must go into .zprofile or .local.zshrc file.
################################################################################


# zsh will read commands in order from:
#
# $ZDOTDIR/.zshenv
# $ZDOTDIR/.zprofile
# $ZDOTDIR/.zshrc
# $ZDOTDIR/.zlogin
# $ZDOTDIR/.zlogout
#
# See http://zsh.sourceforge.net/Intro/intro_3.html

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Uncomment following line if you want to disable autosetting terminal title.
#DISABLE_AUTO_TITLE="true"  # good for tmux

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(zshmarks virtualenvwrapper docker)

source $ZSH/oh-my-zsh.sh

export EDITOR=vim
export PAGER=less
export LESS="-i"  # ignore case
export WORKON_HOME=$HOME/.virtualenvs

# Do not share history between sessions.
unsetopt SHARE_HISTORY

# Do not change directory without "cd" command
unsetopt AUTO_CD 

# my ssh & tmux helper
function ssht() { ssh -t $1 'tmux attach -t cenk || tmux new -s cenk' }

# my sed helper
function searchandreplace()
{
    find . -type f -name '*.'$1 -exec sed -i '' "s/$2/$3/" {} +
}

# COMPLETION SETTINGS
# add custom completion scripts
fpath=(~/.zsh/completion $fpath)

# compsys initialization
autoload -U compinit
compinit

# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

function cg() {
    cd $GOPATH/src/$1;
}

# git aliases
alias g="git st"
alias gp="git push"
alias gti=git
# ...other ones are in .gitconfig file

# shows listening ports
alias listen="sudo lsof -Pn -iTCP -sTCP:LISTEN"

# '[r]emove [o]rphans' - recursively remove ALL orphaned packages
alias pacman-remove-orphan="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rns \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;\$!ba;s/\n/ /g')"

# docker aliases
alias docker-remove-containers="docker ps -a | tail -n +2 | awk '{print \$1}' | xargs docker rm --force"
alias docker-remove-untagged-images="docker images | grep '<none>' | awk '{print \$3}' | xargs docker rmi"

alias gi="go install"
alias gr="go run *.go"

alias t="task"

# nosecomplete
autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit
_nosetests()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=(`nosecomplete ${cur} 2>/dev/null`)
}
complete -o nospace -F _nosetests nosetests

# press ctrl-z to toggle command auto-completion
autoload predict-on
predict-toggle() {
  ((predict_on=1-predict_on)) && predict-on || predict-off
}
zle -N predict-toggle
bindkey '^Z'   predict-toggle
zstyle ':predict' toggle true
zstyle ':predict' verbose true

# press ctrl-x then e to edit current command in editor
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

# show imported packages in go
alias go-list-imports="go list -f '{{join .Deps \"\n\"}}' | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}'"

# colorize man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

source ~/.zshrc_private

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-solarized.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

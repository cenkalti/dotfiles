# zsh will read commands in order from:
#
# $ZDOTDIR/.zshenv
# $ZDOTDIR/.zprofile
# $ZDOTDIR/.zshrc
# $ZDOTDIR/.zlogin
# $ZDOTDIR/.zlogout
#
# See http://zsh.sourceforge.net/Intro/intro_3.html

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

# completion settings
autoload -U compinit bashcompinit
compinit
bashcompinit

# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

# git aliases
alias g="git st"
alias gp="git push"
alias gti=git
# ...other ones are in .gitconfig file

# shows listening ports
alias listening="sudo lsof -Pn -iTCP -sTCP:LISTEN"

# '[r]emove [o]rphans' - recursively remove ALL orphaned packages
alias pacman-remove-orphan="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rns \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;\$!ba;s/\n/ /g')"

# docker aliases
alias docker-remove-containers="docker ps -a | tail -n +2 | awk '{print \$1}' | xargs docker rm --force"
alias docker-remove-untagged-images="docker images | grep '<none>' | awk '{print \$3}' | xargs docker rmi"

# go aliases
alias gi="go install"
alias gr="go run *.go"
# show imported packages in go
alias go-list-imports="go list -f '{{join .Deps \"\n\"}}' | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}'"

# taskwarrior
alias t="task"
function tc() { task $1 modify project:$2 priority:$3 }

# nosecomplete
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

autoload -Uz promptinit
promptinit
prompt redhat

source ~/.zshrc_private

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

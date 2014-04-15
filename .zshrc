# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git, virtualenvwrapper)

export EDITOR=vim

# Must be run after PATHs are set
source $ZSH/oh-my-zsh.sh

# Do not share history between sessions.
unsetopt SHARE_HISTORY

# Customize to your needs...
if [[ -f $HOME/.zshrc-local ]]
then
    source $HOME/.zshrc-local
fi

# my ssh & tmux helper
function ssht()
{
ssh -t $1 'tmux attach -t cenk || tmux new -s cenk'
}

# git aliases
alias g="git st"
# ...other ones are in .gitconfig file

# shows listening ports
alias listen="sudo lsof -Pn -iTCP -sTCP:LISTEN"

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

# set perl home
if [ -d ~/perl5 ]; then
    eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib);
fi

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

# for tmux: do not rename window names automatically
DISABLE_AUTO_TITLE=true

# show imported packages in go
alias go-list-imports="go list -f '{{join .Deps \"\n\"}}' | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}'"

# set env vars
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=$HOME/.gem/ruby/1.8/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$PATH:$HOME/node_modules/.bin
export PATH=$PATH:$HOME/.cabal/bin
export WORKON_HOME=$HOME/.virtualenvs

# set go vars
if type go &> /dev/null; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    export PATH=$PATH:$(go env GOROOT)/bin
fi

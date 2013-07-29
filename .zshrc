# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

# make aliases for frequently used hosts
HOSTS=(x04 x13 x06 zip zip2 db d01 d02 s01 s02 s03 s04 s05 s06 s07 s08 s09 s10 s11 x13 x15 x16 x17 x18 x19 x20 uk munin w24 w25 w26 w27 w28 w29 w30 w31 w32 w33 marvin)
for host in $HOSTS; do
    alias ${host}="ssht ${host}"
done

# git aliases
alias gpp="git pull --no-edit && git push"
alias gppr="git pull --rebase && git push"

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


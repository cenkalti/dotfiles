export CDPATH=$HOME:$HOME/projects

if [[ -d /opt/homebrew ]]; then  # m1 macos
    export BREW_PREFIX=/opt/homebrew
    export PATH=/opt/homebrew/sbin:$PATH
    export PATH=/opt/homebrew/bin:$PATH
elif [[ -f /usr/local/bin/brew ]]; then  # intel macos
    export BREW_PREFIX=/usr/local
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/bin:$PATH
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then  # linux
    export BREW_PREFIX=/home/linuxbrew/.linuxbrew
    export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
    export PATH=/home/linuxbrew/.linuxbrew/sbin:$PATH
fi

if [[ -d $HOME/go/bin ]]; then
    export PATH=$HOME/go/bin:$PATH
fi

if type direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

if [[ -d $HOME/.toolbox/bin ]]; then
    export PATH="$HOME/.toolbox/bin:$PATH"
fi

if [[ -d "$HOME/.yarn" ]]; then
    export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi

if [[ -s "$HOME/.travis/travis.sh" ]]; then
    source "$HOME.travis/travis.sh"
fi

function nvm()  { lazynvm; nvm  $@ }
function node() { lazynvm; node $@ }
function npm()  { lazynvm; npm  $@ }
function npx()  { lazynvm; npx  $@ }
function lazynvm() {
    unset -f nvm node npm npx
    if [[ -d "$HOME/.nvm" ]]; then
        export NVM_DIR="$HOME/.nvm"
    elif [[ -d "/usr/local/opt/nvm" ]]; then
        export NVM_DIR="/usr/local/opt/nvm"
    elif [[ -d "/opt/homebrew/opt/nvm" ]]; then
        export NVM_DIR="/opt/homebrew/opt/nvm"
    fi
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
    if [ -f "$NVM_DIR/bash_completion" ]; then
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    fi
}

if [[ ! "$PATH" == *$BREW_PREFIX/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}$BREW_PREFIX/opt/fzf/bin"
    [[ $- == *i* ]] && source "$BREW_PREFIX/opt/fzf/shell/completion.zsh" 2> /dev/null
    source "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
fi

export CDPATH=$HOME:$HOME/projects

if [[ -d /opt/homebrew ]]; then  # m1 macos
    export HOMEBREW_PREFIX=/opt/homebrew
    export PATH=/opt/homebrew/sbin:$PATH
    export PATH=/opt/homebrew/bin:$PATH
elif [[ -f /usr/local/bin/brew ]]; then  # intel macos
    export HOMEBREW_PREFIX=/usr/local
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/bin:$PATH
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then  # linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [[ -d "$HOMEBREW_PREFIX/opt/mysql-client/bin" ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/mysql-client/bin:$PATH"
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

if [[ -d "$HOMEBREW_PREFIX/opt/node@14/bin" ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/node@14/bin:$PATH"
fi

if [[ ! "$PATH" == *$HOMEBREW_PREFIX/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}$HOMEBREW_PREFIX/opt/fzf/bin"
    [[ $- == *i* ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" 2> /dev/null
    if [[ -f $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh ]]; then
        source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
    fi
fi

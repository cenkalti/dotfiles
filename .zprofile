export CDPATH=$HOME:$HOME/projects:$HOME/workspace

if [[ -d /opt/homebrew ]]; then  # m1 macos
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then  # linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

if type atuin &>/dev/null; then
    eval "$(atuin init zsh)"
fi

if [[ -d "$HOMEBREW_PREFIX/opt/mysql-client/bin" ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/mysql-client/bin:$PATH"
fi

if [[ -d $HOME/.local/bin ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d $HOME/go/bin ]]; then
    export PATH=$HOME/go/bin:$PATH
fi

if [[ -f $HOME/.cargo/env ]]; then
    source "$HOME/.cargo/env"
fi

# Linters, formatters, etc.
if [[ -d "$HOME/.local/share/nvim/mason/bin" ]]; then
    export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
fi

if type direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

if [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]]; then
    source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
elif [[ -f "/usr/share/fzf/key-bindings.zsh" ]]; then
    source "/usr/share/fzf/key-bindings.zsh"
fi

if [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]]; then
    source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
    if [[ ! "$PATH" == *$HOMEBREW_PREFIX/opt/fzf/bin* ]]; then
        export PATH="${PATH:+${PATH}:}$HOMEBREW_PREFIX/opt/fzf/bin"
        [[ $- == *i* ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" 2> /dev/null
    fi
elif [[ -f "/usr/share/fzf/completion.zsh" ]]; then
    source "/usr/share/fzf/completion.zsh"
fi

# Created by `pipx`
export PATH="$PATH:$HOME/.local/bin"

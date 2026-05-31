# .zshenv - Always sourced, keep minimal:
#
# Essential environment variables needed by all shells (PATH modifications, EDITOR, PAGER)
# Used by both interactive and non-interactive shells
# Keep it fast and side-effect free

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=nvim

export CDPATH="$HOME:$HOME/projects:$HOME/workspace:$HOME/.config:/opt"

if [[ -d /opt/homebrew ]]; then  # m1 macos
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then  # linux
    # TODO: remove command call, set variables directly
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
    FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
fi

if [[ -d "$HOMEBREW_PREFIX/opt/mysql-client/bin" ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/mysql-client/bin:$PATH"
fi

if [[ -d $HOME/.local/bin ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d $HOME/.yarn/bin ]]; then
    export PATH="$HOME/.yarn/bin:$PATH"
fi

if [[ -d $HOME/go/bin ]]; then
    export PATH="$HOME/go/bin:$PATH"
fi

if [[ -d $HOME/.cargo/bin ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ -d $HOME/.local/bin ]]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

if [[ -d $HOME/.bun ]]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

if [[ -d $HOME/.krew ]]; then
    export KREW_ROOT="$HOME/.krew"
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# Wrap nvim so every wezterm-spawned instance listens on a window-scoped socket.
# Lets external tooling drive the same nvim via `nvim --server <sock> --remote`.
nvim() {
    local socket=""
    if [[ -n "$WEZTERM_PANE" ]] && (( $+commands[wezterm] )) && (( $+commands[jq] )); then
        local window_id
        window_id=$(wezterm cli list --format json 2>/dev/null \
            | jq -r ".[] | select(.pane_id == ${WEZTERM_PANE}) | .window_id" 2>/dev/null \
            | head -1)
        if [[ -n "$window_id" ]]; then
            socket="$HOME/.work/run/nvim-wez-${window_id}.sock"
            if [[ -S "$socket" ]] && command nvim --server "$socket" --remote-expr '1' >/dev/null 2>&1; then
                socket=""
            else
                rm -f "$socket" 2>/dev/null
            fi
        fi
    fi
    local -a cmd=(command nvim)
    if [[ -n "$socket" ]]; then
        mkdir -p "${socket:h}"
        cmd+=(--listen "$socket")
    fi
    cmd+=("$@")
    if [[ -o interactive ]]; then
        "${cmd[@]}"
    else
        exec "${cmd[@]}"
    fi
}

###############################################################################
# If you are setting a local environment variable, do it in ~/.local.zshenv
###############################################################################
if [[ -f $HOME/.local.zshenv ]]; then
    source $HOME/.local.zshenv
fi
###############################################################################
# Do not add anything below this line
###############################################################################

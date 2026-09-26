# .zshenv - Always sourced, keep minimal:
#
# Essential environment variables needed by all shells (PATH modifications, EDITOR, PAGER)
# Used by both interactive and non-interactive shells
# Keep it fast and side-effect free

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=nvim

# Keep the tsh/tctl you invoked. Without this, client tools managed updates
# download the version the logged-in cluster asks for and re-exec into it, so a
# locally built tsh silently hands the whole invocation to a stock release.
# Here rather than in .config/zsh/env.zsh so scripts and other non-interactive
# shells get it too.
export TELEPORT_TOOLS_VERSION=off

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
# Lets external tooling drive the same nvim via `nvim --server <sock> --remote`
# (~/.local/bin/open-in-nvim, .config/wezterm/file_picker.lua).
#
# The window has to be derived from live state, never from $WEZTERM_PANE. Inside
# tmux that variable is not this pane: tmux captures it once, when the *session*
# is created, and hands the same value to every pane in it, so it names whichever
# tab the session was born in — usually one closed since. Measured here: editors
# in four tmux sessions were carrying panes 226, 94, 244 and 255 when only 244
# and 255 still existed. Since the old code only opened a socket when the pane
# resolved, a stale one meant *no* --listen at all and nothing could drive that
# editor; a live one belonging to some other tab put the socket under the wrong
# window's name. internal/muxer's currentPane() derives it the same way this
# does, and documents the same trap.
#
# What is true instead: a WezTerm pane showing this shell is the one running the
# tmux client we are attached to, so the client's tty is that pane's tty. Outside
# tmux there is no indirection and $WEZTERM_PANE is honest.
nvim() {
    local socket=""
    if (( $+commands[wezterm] )) && (( $+commands[jq] )); then
        local panes window_id
        panes=$(wezterm cli list --format json 2>/dev/null)
        if [[ -n "$TMUX" ]]; then
            local tty
            tty=$(command tmux display-message -p '#{client_tty}' 2>/dev/null)
            [[ -n "$tty" ]] && window_id=$(print -r -- "$panes" \
                | jq -r --arg tty "$tty" '.[] | select(.tty_name == $tty) | .window_id' 2>/dev/null \
                | head -1)
        elif [[ -n "$WEZTERM_PANE" ]]; then
            window_id=$(print -r -- "$panes" \
                | jq -r --argjson id "$WEZTERM_PANE" '.[] | select(.pane_id == $id) | .window_id' 2>/dev/null \
                | head -1)
        fi
        if [[ -n "$window_id" ]]; then
            # A name that answers belongs to a live editor — a second agent tab
            # in this window, since agents are tabs and one window holds several.
            # Take the next name rather than starting with no socket at all: an
            # editor nothing can address is the failure this wrapper exists to
            # prevent, and its callers read the socket off the running process
            # rather than recomputing the name, so a suffixed one costs nothing.
            #
            # --headless on the probe is load-bearing. An nvim client that finds
            # a tty brings up a full UI before it gets to the RPC: about a second
            # per call, and it paints an alternate-screen sequence over the very
            # terminal it was probing from. Both measured.
            local base="$HOME/.work/run/nvim-wez-${window_id}" n=1
            socket="${base}.sock"
            while [[ -S "$socket" ]] && \
                command nvim --headless --server "$socket" --remote-expr '1' >/dev/null 2>&1; do
                (( ++n ))
                (( n > 9 )) && { socket=""; break; }
                socket="${base}-${n}.sock"
            done
            # Whatever we settled on is not answering, so any file there is a
            # leftover from a dead editor.
            [[ -n "$socket" ]] && rm -f "$socket" 2>/dev/null
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

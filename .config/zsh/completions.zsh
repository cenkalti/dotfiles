# Completion subsystem and tool integrations.

# enable completion subsystem
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

# Cache slow `eval "$(... completion ...)"` outputs to disk.
# Regenerates when the binary is newer than the cache.
_zsh_cache_dir="$HOME/.cache/zsh"
[[ -d $_zsh_cache_dir ]] || mkdir -p $_zsh_cache_dir
cached_eval() {
  local name=$1; shift
  local cache="$_zsh_cache_dir/$name.zsh"
  local bin
  bin=$(whence -p "$name" 2>/dev/null) || return
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    "$@" > $cache 2>/dev/null
  fi
  source $cache
}

cached_eval kubectl kubectl completion zsh
cached_eval direnv direnv hook zsh
cached_eval tsh tsh --completion-script-zsh
cached_eval tctl tctl --completion-script-zsh

type aws &> /dev/null && type aws_completer &>/dev/null && complete -C aws_completer aws
type fnm &> /dev/null && eval "$(fnm env --use-on-cd --log-level quiet --shell zsh)"

if type atuin &>/dev/null; then
    export ATUIN_NOBIND="true"
    eval "$(atuin init zsh)"
    bindkey '^r' atuin-search
elif [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]]; then
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

# bun
[ -s "/Users/cenk/.bun/_bun" ] && source "/Users/cenk/.bun/_bun"

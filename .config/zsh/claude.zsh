# Claude Code shell helper
_claude_zsh() {
if [[ -n "$BUFFER" ]]; then
    local prompt="$BUFFER"
    print -s "$prompt"
    zle -R "Thinking..."

    # Capture terminal context
    local context=""
    if [[ -n "$TMUX" ]]; then
      context=$(tmux capture-pane -p -S -100 2>/dev/null)
    elif [[ -n "$WEZTERM_PANE" ]]; then
      context=$(wezterm cli get-text --pane-id "$WEZTERM_PANE" 2>/dev/null | tail -100)
    fi

    local full_prompt="You are a shell command generator. The user is asking for help in their terminal.

Terminal context (last lines of output):
$context

User request: $prompt

Respond with ONLY the shell command. No explanation, no markdown, no code fences. Just the raw command."

    local tmpfile=$(mktemp)
    env -u ANTHROPIC_API_KEY claude -p "$full_prompt" --output-format text > "$tmpfile" 2>/dev/null </dev/null
    BUFFER=$(<"$tmpfile")
    rm -f "$tmpfile"
    zle end-of-line
fi
}
zle -N _claude_zsh
bindkey '^[\' _claude_zsh  # Alt-\

#!/opt/homebrew/bin/zsh
# fzf-based workspace picker for WezTerm. Mirrors the agent picker:
# selection is routed back into WezTerm via an OSC 1337 user-var that
# workspace_switcher.lua turns into a SwitchToWorkspace.
#
# Modes:
#   workspace-pick.sh --preview <ws>   render the panes in <ws> (used by fzf)
#   workspace-pick.sh <ws>...          run the picker over the given names

fzf=/opt/homebrew/bin/fzf
jq=/opt/homebrew/bin/jq
wezterm=/opt/homebrew/bin/wezterm

if [[ $1 == --preview ]]; then
    "$wezterm" cli list --format json \
        | "$jq" -r --arg ws "$2" '
            .[] | select(.workspace == $ws)
            | "[\(.tab_id)] \(if .tab_title != "" then .tab_title else .title end)\t\(.cwd | sub("^file://[^/]*"; ""))"' \
        | column -t -s $'\t'
    exit 0
fi

self=${0:A}

out=$(printf '%s\n' "$@" | "$fzf" \
    --style minimal \
    --ansi \
    --layout reverse \
    --tiebreak index \
    --print-query \
    --expect ctrl-x \
    --prompt 'workspace> ' \
    --border rounded \
    --border-label 'enter: switch/create · ^X: create typed name' \
    --border-label-pos '0:bottom' \
    --preview "$self --preview {}" \
    --preview-window 'right:55%')
code=$?

# With --print-query --expect, fzf prints: line1 = query, line2 = the expect
# key (empty for plain Enter), line3 = the highlighted item (if any).
query=$(printf '%s' "$out" | sed -n 1p)
key=$(printf '%s' "$out" | sed -n 2p)
sel=$(printf '%s' "$out" | sed -n 3p)

# 130/2 = ESC or error: do nothing. Otherwise: ^X always uses the typed text
# verbatim (create it even when it fuzzy-matches a row); plain Enter uses the
# highlighted match, falling back to the typed text when nothing matched.
if [[ $code -ne 0 && $code -ne 1 ]]; then
    exit 0
fi
if [[ $key == ctrl-x ]]; then
    target=$query
elif [[ -n $sel ]]; then
    target=$sel
else
    target=$query
fi

[[ -z $target ]] && exit 0

emit() {
    local b64
    b64="$(printf '%s' "$2" | base64 | tr -d '\n')"
    printf '\033]1337;SetUserVar=%s=%s\a' "$1" "$b64" > /dev/tty
}

# Emit the chosen target as an OSC user-var for workspace_switcher.lua. The salt
# forces a fresh value each press so WezTerm doesn't dedupe the change event.
salt="$(date +%s)$RANDOM$$"
emit pick_workspace "$salt $target"

# Then exit: the process exiting destroys this pane at the mux level, which is
# how the picker closes itself (no Lua close, so nothing can clobber the switch).
# The brief sleep lets WezTerm read+process the OSC while the pane is still
# alive; the switch lands in ~ms, well before this fires.
sleep 0.2

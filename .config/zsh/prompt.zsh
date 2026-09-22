# Prompt, window/tab title, and terminal shell-integration hooks.

function set_title {
  emulate -L zsh
  setopt prompt_subst
  local tab_name=$1
  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      # These are OSC control sequences.
      # Terminals that support these sequences will change the title.
      # If you are using tmux, it will change the title of the pane.
      # For setting the window title in tmux, configure in your tmux.conf.
      print -Pn "\e]0;$tab_name:q\a"
      ;;
  esac
}

# Runs before showing the prompt
function precmd {
  emulate -L zsh
  set_title "%1~"
}

# Report the working directory with OSC 7. tmux keeps it as #{pane_path} and,
# given the osc7 terminal feature in .tmux.conf, forwards it to WezTerm, so new
# tabs and panes open where this shell is. Everything outside the unreserved
# set is percent-encoded, so spaces and % survive the round trip.
function _osc7_cwd {
  emulate -L zsh
  setopt extendedglob
  local url=${PWD//(#m)[^a-zA-Z0-9_.\/-]/%${(l:2::0:)$(([##16]#MATCH))}}
  printf '\033]7;file://%s%s\033\\' "$HOST" "$url"
}
precmd_functions+=(_osc7_cwd)

# Runs before executing the command
function preexec {
    local cmd="$1"

    # List of prefixes to strip
    prefixes=(
        "sudo"
        "ssh"
        "ssht"
        "mosh"
        "mt"
        "poetry run"
        "pdm run"
        "uv run"
        "python -m"
        "python3 -m"
    )

    for prefix in "${prefixes[@]}"; do
        # Check if command starts with the prefix
        if [[ "$1" = "$prefix"* ]]; then
            # Remove prefix and any leading whitespace
            cmd="${1#$prefix}"
            cmd="${cmd#"${cmd%%[![:space:]]*}"}"
            break
        fi
    done

    # Get only the first word
    cmd="${cmd%% *}"

    set_title "$cmd"
}

precmd_functions+=(precmd)
preexec_functions+=(preexec)

SPACESHIP_PROMPT_ADD_NEWLINE=false
if [ -f "/opt/homebrew/opt/spaceship/spaceship.zsh" ]; then
  source "/opt/homebrew/opt/spaceship/spaceship.zsh"
fi
if [ -f "/usr/lib/spaceship-prompt/spaceship.zsh" ]; then
  source "/usr/lib/spaceship-prompt/spaceship.zsh"
fi

# OSC 133 shell integration for WezTerm
function _osc133_preexec {
  print -n "\e]133;B\a"  # end of prompt / start of user input
  print -n "\e]133;C\a"  # start of command output
}
function _osc133_precmd {
  print -n "\e]133;D;$?\a"  # end of command output (with exit status)
  print -n "\e]133;A\a"     # start of prompt
}

# Load project specific aliases, etc.
load-local-aliases() {
  if [[ -f aliases.sh && -r aliases.sh ]]; then
    source aliases.sh
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec _osc133_preexec
add-zsh-hook precmd _osc133_precmd
add-zsh-hook precmd load-local-aliases

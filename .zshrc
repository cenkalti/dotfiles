# .zshrc - Interactive shells (your main config):
#
# Aliases, functions, keybindings
# Prompt configuration
# Shell options (setopt)
# Completions
# Plugin managers (oh-my-zsh, etc.)
#
# zsh will read commands in order from:
#
# $ZDOTDIR/.zshenv    # sourced in all invocations
# $ZDOTDIR/.zprofile  # sourced in login shells, before zshrc
# $ZDOTDIR/.zshrc     # sourced in interactive shells
# $ZDOTDIR/.zlogin    # sourced in login shells, after zshrc
# $ZDOTDIR/.zlogout   # sourced in login shells, on logout
#
# See http://zsh.sourceforge.net/Intro/intro_3.html
#
# Config is split by purpose into ~/.config/zsh/*.zsh, sourced below in order.
# Order matters: options first, plugins (zsh-syntax-highlighting) last.

for _rc in options env aliases functions completions prompt plugins claude; do
  source "$HOME/.config/zsh/$_rc.zsh"
done
unset _rc

###############################################################################
# If you are setting a local environment variable, do it in ~/.local.zshenv
###############################################################################
if [[ -f $HOME/.local.zshrc ]]; then
    source $HOME/.local.zshrc
fi
###############################################################################
# Do not add anything below this line
###############################################################################

# cooldowns:yarn:start
export YARN_NPM_MINIMAL_AGE_GATE="4320"
# cooldowns:yarn:end
# cooldowns:uv:start
export UV_EXCLUDE_NEWER="3 days"
# cooldowns:uv:end
# cooldowns:pip:start
export PIP_UPLOADED_PRIOR_TO="P3D"
# cooldowns:pip:end

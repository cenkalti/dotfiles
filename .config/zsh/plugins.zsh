# Shell plugins and integrations. Keep zsh-syntax-highlighting last.

if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey '^[y' autosuggest-accept
elif [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey '^[y' autosuggest-accept
fi
if [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
if [ -f "/usr/share/doc/pkgfile/command-not-found.zsh" ]; then
  source "/usr/share/doc/pkgfile/command-not-found.zsh"
fi

if [ -f "/Users/cenk/projects/work/shell/work.zsh" ]; then
  source "/Users/cenk/projects/work/shell/work.zsh"
fi

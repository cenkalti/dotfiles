# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Model

A bare repo plus one worktree:

- `~/projects/dotfiles.git/` — the **bare repo**. No working tree; just refs, objects, and `worktrees/`.
- `$HOME` — the only worktree. `$HOME/.git` is a one-line gitfile pointing into `~/projects/dotfiles.git/worktrees/home/`. Deployed dotfiles live here.

All editing of dotfiles happens directly in `$HOME`.

## Layout

- `.zshrc`, `.zshenv`, `.zprofile`, `.tmux.conf`, `.aerospace.toml`, `.Brewfile` — top-level shell/wm/tool configs that land directly in `$HOME`.
- `.config/` — XDG configs (nvim, wezterm, alacritty, lazygit, k9s, git, atuin, direnv, ptpython, black, flake8, pycodestyle, stylua, spaceship.zsh, pip).
- `.claude/` — Claude Code settings and statusline script for this machine.
- `.hammerspoon/` — Hammerspoon Lua config (Spoons/EmmyLua.spoon is gitignored).
- `.githooks/pre-commit` — blocks staged files > 10 MB (override via `GIT_MAX_FILE_SIZE`).
- `.local/bin/claude-usage` — local helper script.
- `.install.sh` — bootstrap that clones the repo as bare to `~/projects/dotfiles.git` and registers `$HOME` as the linked worktree.

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Model

A bare repo plus one worktree:

- `~/projects/dotfiles.git/` — the **bare repo**. No working tree; just refs, objects, and `worktrees/`.
- `$HOME` — the only worktree. `$HOME/.git` is a one-line gitfile pointing into `~/projects/dotfiles.git/worktrees/home/`. Deployed dotfiles live here.

All editing of dotfiles happens directly in `$HOME`. The harness spawns additional linked worktrees of this bare repo under `~/.work/tree/dotfiles/<task>/` via `agent run dotfiles/<task>`.

Owner is doing a cleanup pass on historical artifacts, so be willing to recommend deletions of clearly stale files rather than preserving them by default.

## Layout

- `.zshrc`, `.zshenv`, `.zprofile`, `.tmux.conf`, `.aerospace.toml`, `.Brewfile` — top-level shell/wm/tool configs that land directly in `$HOME`.
- `.config/` — XDG configs (nvim, wezterm, alacritty, lazygit, k9s, git, atuin, direnv, ptpython, black, flake8, pycodestyle, stylua, spaceship.zsh, pip).
- `.claude/` — Claude Code settings and statusline script for this machine.
- `.hammerspoon/` — Hammerspoon Lua config (Spoons/EmmyLua.spoon is gitignored).
- `.githooks/pre-commit` — blocks staged files > 10 MB (override via `GIT_MAX_FILE_SIZE`).
- `bin/claude-usage` — local helper script.
- `.install.sh` — bootstrap that clones the repo as bare to `~/projects/dotfiles.git` and registers `$HOME` as the linked worktree.

## Conventions

- One-line commit messages, under 50 chars (e.g. `claude: keep history`, `wez: use harness workspace switcher`). Prefix with the tool/area being touched.
- `.golangci.yml` and `.actrc` exist at the root but there is no Go or CI code in the repo — they ship as user-level defaults for whatever project the user `cd`s into.

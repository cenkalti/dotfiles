# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Model

One git repo, two worktrees:

- `~/projects/dotfiles/` — the **main worktree**. Has a real `.git/` directory. This is what the harness mounts and where most editing happens.
- `$HOME` — a **linked worktree** of the same repo (`git worktree add`). `$HOME/.git` is a one-line gitfile pointing into `~/projects/dotfiles/.git/worktrees/home/`. Deployed dotfiles live here.

Both worktrees stay on `master`. A commit from either advances the branch; the other worktree is "stale" until refreshed with `git reset --hard`.

When the user says "add file X to dotfiles," it can be staged from either worktree — same repo. Use whichever is convenient: edits to files that live in `$HOME` (e.g. `.zshrc`) are easier from there; edits to files inside `~/projects/dotfiles/` (e.g. this `CLAUDE.md`) are easier from the main worktree.

Owner is doing a cleanup pass on historical artifacts, so be willing to recommend deletions of clearly stale files rather than preserving them by default.

## Layout

- `.zshrc`, `.zshenv`, `.zprofile`, `.tmux.conf`, `.aerospace.toml`, `.Brewfile` — top-level shell/wm/tool configs that land directly in `$HOME`.
- `.config/` — XDG configs (nvim, wezterm, alacritty, lazygit, k9s, git, atuin, direnv, ptpython, black, flake8, pycodestyle, stylua, spaceship.zsh, pip).
- `.claude/` — Claude Code settings and statusline script for this machine.
- `.hammerspoon/` — Hammerspoon Lua config (Spoons/EmmyLua.spoon is gitignored).
- `.githooks/pre-commit` — blocks staged files > 10 MB (override via `GIT_MAX_FILE_SIZE`).
- `bin/claude-usage` — local helper script.
- `.install.sh` — bootstrap that clones the repo into `~/projects/dotfiles` and registers `$HOME` as a linked worktree.

## Conventions

- One-line commit messages, under 50 chars (e.g. `claude: keep history`, `wez: use harness workspace switcher`). Prefix with the tool/area being touched.
- `.golangci.yml` and `.actrc` exist at the root but there is no Go or CI code in the repo — they ship as user-level defaults for whatever project the user `cd`s into.
- `workspace` is a symlink into `~/.work/space/dotfiles` (harness-managed); don't commit changes through it.

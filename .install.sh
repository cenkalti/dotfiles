#!/bin/bash -e
git clone "$REPO" "$HOME/projects/dotfiles"
cd "$HOME/projects/dotfiles"

# git worktree add refuses non-empty paths, so create at a temp path and relocate
# to register $HOME as a linked worktree of the same repo.
TMP=$(mktemp -d -t dotfiles-home-wt)
rmdir "$TMP"
git worktree add -f --no-checkout "$TMP" master
META_ID=$(basename "$TMP")
mv ".git/worktrees/$META_ID" ".git/worktrees/home"
mv "$TMP/.git" "$HOME/.git"
rmdir "$TMP"
printf 'gitdir: %s/projects/dotfiles/.git/worktrees/home\n' "$HOME" > "$HOME/.git"
printf '%s/.git\n' "$HOME" > ".git/worktrees/home/gitdir"

# Per-worktree config so $HOME doesn't trip fsmonitor or list thousands of untracked.
git config extensions.worktreeConfig true
git -C "$HOME" config --worktree core.fsmonitor false
git -C "$HOME" config --worktree core.untrackedCache false
git -C "$HOME" config --worktree status.showUntrackedFiles no

# Seed the $HOME worktree's index from HEAD without overwriting working-tree files.
git -C "$HOME" reset

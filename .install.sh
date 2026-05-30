#!/bin/bash -e
git clone --bare "$REPO" "$HOME/projects/dotfiles.git"
cd "$HOME/projects/dotfiles.git"

# Register $HOME as the single worktree. git worktree add refuses non-empty
# paths, so add at a temp path and relocate the gitfile to $HOME.
TMP=$(mktemp -d -t dotfiles-home-wt)
rmdir "$TMP"
git worktree add -f --no-checkout "$TMP" master
META_ID=$(basename "$TMP")
mv "worktrees/$META_ID" "worktrees/home"
mv "$TMP/.git" "$HOME/.git"
rmdir "$TMP"
printf 'gitdir: %s/projects/dotfiles.git/worktrees/home\n' "$HOME" > "$HOME/.git"
printf '%s/.git\n' "$HOME" > "worktrees/home/gitdir"

# Per-worktree config: override the bare flag for $HOME and skip
# fsmonitor/untracked-cache thrash over the full home directory.
git config extensions.worktreeConfig true
git -C "$HOME" config --worktree core.bare false
git -C "$HOME" config --worktree core.fsmonitor false
git -C "$HOME" config --worktree core.untrackedCache false
git -C "$HOME" config --worktree status.showUntrackedFiles no

# Seed the $HOME worktree's index from HEAD without overwriting working-tree files.
git -C "$HOME" reset

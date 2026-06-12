# cenkalti's dotfiles

A **bare** git repo at `~/projects/dotfiles.git` with `$HOME` registered as its single linked worktree. `$HOME/.git` is a one-line gitfile pointing into the bare repo, so plain `git` commands run from anywhere under `$HOME` operate on the dotfiles.

## Installation

Clone using the following command:
```sh
export REPO="git@github.com:cenkalti/dotfiles"
# for read-only access
# export REPO="https://github.com/cenkalti/dotfiles.git"
curl 'https://raw.githubusercontent.com/cenkalti/dotfiles/master/.install.sh' | bash
```

## Usage

Plain `git` works from `$HOME`:
```sh
cd ~
git add .vimrc
git commit -m "add .vimrc file"
git push
```

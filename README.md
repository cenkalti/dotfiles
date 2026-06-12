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

The bootstrap seeds the index but does **not** write files into `$HOME`, so it never clobbers configs already there. Deploy the tracked files afterward:
```sh
git -C ~ checkout .          # deploy everything (overwrites existing files)
# or, to keep any files already present:
git -C ~ checkout-index -a   # only write files that don't exist yet
```

## Usage

Plain `git` works from `$HOME`:
```sh
cd ~
git add .vimrc
git commit -m "add .vimrc file"
git push
```

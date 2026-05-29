# cenkalti's dotfiles

The repo is checked out as a normal clone at `~/projects/dotfiles`, with `$HOME` registered as a linked git worktree of the same repo. Both worktrees stay on `master`; commits from either advance the branch and the other catches up with `git reset --hard`.

## Installation

Clone using the following command:
```sh
export REPO="git@github.com:cenkalti/dotfiles"
# for read-only access
# export REPO="https://github.com/cenkalti/dotfiles.git"
curl 'https://raw.githubusercontent.com/cenkalti/dotfiles/master/.install.sh' | bash
```

## Usage

Plain `git` works from either worktree:
```sh
cd ~
git add .vimrc
git commit -m "add .vimrc file"
git push
```

After a commit in one worktree, refresh the other:
```sh
git -C ~ reset --hard                    # refresh $HOME
git -C ~/projects/dotfiles reset --hard  # refresh main checkout
```

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

Add this to your `.zshrc` (or already present after install):
```sh
alias dotfiles='git -C $HOME'
```

## Usage

`dotfiles` is just `git` rooted at `$HOME`:
```sh
dotfiles pull
dotfiles add .vimrc
dotfiles commit -m "add .vimrc file"
dotfiles push
```

After a commit in `~/projects/dotfiles`, refresh `$HOME`:
```sh
dotfiles reset --hard
```

And vice versa: after a commit from `$HOME`, refresh the main checkout:
```sh
git -C ~/projects/dotfiles reset --hard
```

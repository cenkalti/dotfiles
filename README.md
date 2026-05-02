# cenkalti's dotfiles

## Installation

Clone using following command:
```sh
export REPO="git@github.com:cenkalti/dotfiles"
# for read-only access
# export REPO="https://github.com/cenkalti/dotfiles.git"
curl 'https://raw.githubusercontent.com/cenkalti/dotfiles/master/.install.sh' | bash
```

Add this to your `.bashrc`/`.zshrc` file:
```sh
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Checkout files:
```sh
dotfiles reset --hard
```

Disable fsmonitor for this repo (the daemon hangs when `--work-tree` is `$HOME`):
```sh
dotfiles config core.fsmonitor false
dotfiles config core.untrackedCache false
```

## Usage

Use `dotfiles` command instead of `git`:
```sh
dotfiles pull
dotfiles add .vimrc
dotfiles commit -m "add .vimrc file"
dotfiles push
```

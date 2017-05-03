# cenkalti's dotfiles

## Installation

Clone using following command:
```sh
REPO="git@github.com:cenkalti/dotfiles" curl 'https://raw.githubusercontent.com/cenkalti/dotfiles/master/.install.sh' | bash
```

Add this to your `.bashrc`/`.zshrc` file:
```sh
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

## Usage

Use `dotfiles` command instead of `git`:
```sh
dotfiles pull
dotfiles add .vimrc
dotfiles commit -m "add .vimrc file"
dotfiles push
```
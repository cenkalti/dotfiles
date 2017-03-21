# cenkalti's dotfiles

## Installation

Clone using following command:
```sh
export REPO="git@github.com:cenkalti/dotfiles"
git clone --separate-git-dir=$HOME/.dotfiles $REPO $HOME/dotfiles-tmp \
    && rm -r ~/dotfiles-tmp/ \
    && git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config status.showUntrackedFiles no
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

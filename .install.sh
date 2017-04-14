#!/bin/bash -e
tempdir=$(mktemp -d -t dotfiles)
git clone --separate-git-dir=$HOME/.dotfiles $REPO $tempdir
rm -r $tempdir
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME update-index --assume-unchanged README.md

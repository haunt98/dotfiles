#!/usr/bin/env bash

echo "Must run this script inside dotfiles directory"

rsync -vah --delete ./nvim ~/.config/
rsync -vah --delete ./tmux ~/.config/

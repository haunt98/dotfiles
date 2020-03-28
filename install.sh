#!/bin/bash

rsync -vah ./tmux/tmux.conf ~/.tmux.conf

rsync -vah --delete ./alacritty ~/.config/
rsync -vah --delete ./bat ~/.config/
rsync -vah --delete ./mpv ~/.config/
rsync -vah --delete ./nvim ~/.config/

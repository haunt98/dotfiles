#!/bin/bash

rsync -vah --delete ./bat ~/.config/
rsync -vah --delete ./mpv ~/.config/
rsync -vah --delete ./nvim ~/.config/
rsync -vah --delete ./tmux ~/.config/

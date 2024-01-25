#!/usr/bin/env bash

git -C ~/.oh-my-zsh pull
git -C ~/.oh-my-zsh/custom/themes/powerlevel10k pull
git -C ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions pull

git -C ~/.fzf pull
~/.fzf/install --key-bindings --no-completion --update-rc --no-bash --no-fish

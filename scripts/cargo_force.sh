#!/usr/bin/env bash

cargo install --quiet --force --locked \
    fd-find bat git-delta eza sd tealdeer \
    difftastic vivid zellij zoxide atuin \
    fnm stylua taplo-cli \
    pfetch pokeget \
    daktilo kbt

cargo install --quiet --force --locked ripgrep --features 'pcre2'

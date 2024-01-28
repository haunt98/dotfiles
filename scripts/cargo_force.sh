#!/usr/bin/env bash

cargo install --force --locked \
    fd-find bat git-delta eza sd tealdeer \
    difftastic vivid zellij zoxide \
    fnm stylua taplo-cli \
    pfetch pokeget \
    daktilo kbt

cargo install --force --locked ripgrep --features 'pcre2'

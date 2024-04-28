#!/usr/bin/env bash

cargo install --quiet --force --locked \
    fd-find bat git-delta eza sd tlrc \
    difftastic vivid zellij zoxide atuin gitui \
    fnm stylua taplo-cli \
    pokeget \
    daktilo

cargo install --quiet --force --locked ripgrep --features 'pcre2'

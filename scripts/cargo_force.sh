#!/usr/bin/env bash

cargo install --quiet --force --locked \
    fd-find bat git-delta eza sd tlrc \
    difftastic vivid zellij zoxide atuin gitui \
    fnm stylua taplo-cli \
    pfetch yazi-fm pokeget \
    daktilo kbt

cargo install --quiet --force --locked ripgrep --features 'pcre2'

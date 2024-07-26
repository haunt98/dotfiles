#!/usr/bin/env bash

cargo install --force \
    fd-find bat git-delta eza sd tlrc \
    difftastic vivid zellij zoxide \
    stylua typos-cli \
    pokeget \
    daktilo

cargo install --force --git https://github.com/BurntSushi/ripgrep ripgrep --features 'pcre2'
cargo install --force --git https://github.com/Schniz/fnm fnm
cargo install --force --git https://github.com/astral-sh/rye rye
cargo install --force --git https://github.com/tamasfe/taplo taplo-cli

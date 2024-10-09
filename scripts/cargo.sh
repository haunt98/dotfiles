#!/usr/bin/env bash

rustup update

cargo install \
    fd-find bat git-delta eza sd \
    difftastic zoxide

cargo install --git https://github.com/BurntSushi/ripgrep ripgrep --features 'pcre2'

bat cache --build

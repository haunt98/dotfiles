#!/usr/bin/env bash

rustup update

cargo install --quiet --locked \
    fd-find bat git-delta eza sd tealdeer \
    difftastic vivid zellij zoxide atuin \
    fnm stylua taplo-cli \
    pfetch pokeget \
    daktilo kbt

cargo install --quiet --locked ripgrep --features 'pcre2'

bat cache --build

pokeget --hide-name pikachu >data/pokeget/pikachu.txt
pokeget --hide-name clefairy >data/pokeget/clefairy.txt
pokeget --hide-name ditto >data/pokeget/ditto.txt
pokeget --hide-name chikorita >data/pokeget/chikorita.txt
pokeget --hide-name eevee >data/pokeget/eevee.txt
pokeget --hide-name squirtle >data/pokeget/squirtle.txt

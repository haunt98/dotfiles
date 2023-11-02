#!/usr/bin/env bash

rustup update

cargo install --locked \
    fd-find bat ripgrep git-delta eza tealdeer \
    difftastic vivid zellij zoxide \
    fnm stylua taplo-cli \
    pfetch pokeget \
    daktilo kbt

bat cache --build

pokeget --hide-name pikachu >data/pokeget/pikachu.txt
pokeget --hide-name clefairy >data/pokeget/clefairy.txt
pokeget --hide-name ditto >data/pokeget/ditto.txt
pokeget --hide-name chikorita >data/pokeget/chikorita.txt
pokeget --hide-name eevee >data/pokeget/eevee.txt
pokeget --hide-name squirtle >data/pokeget/squirtle.txt

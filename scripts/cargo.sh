#!/usr/bin/env bash

rustup update

cargo install \
    fd-find bat ripgrep git-delta exa tealdeer \
    difftastic vivid \
    fnm stylua taplo-cli \
    pfetch pokeget

bat cache --build

pokeget --hide-name pikachu >data/pokeget/pikachu.txt
pokeget --hide-name clefairy >data/pokeget/clefairy.txt
pokeget --hide-name ditto >data/pokeget/ditto.txt
pokeget --hide-name chikorita >data/pokeget/chikorita.txt

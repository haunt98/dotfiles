#!/usr/bin/env bash

rustup update

cargo install --quiet --locked \
    fd-find bat git-delta eza sd tlrc \
    difftastic vivid zellij zoxide \
    stylua taplo-cli typos-cli \
    pokeget \
    daktilo

cargo install --quiet --locked ripgrep --features 'pcre2'
cargo install --quiet --git https://github.com/Schniz/fnm fnm
cargo install --quiet --git https://github.com/astral-sh/rye rye

bat cache --build

pokeget --hide-name bulbasaur >data/pokeget/bulbasaur.txt
pokeget --hide-name charmeleon >data/pokeget/charmeleon.txt
pokeget --hide-name chikorita >data/pokeget/chikorita.txt
pokeget --hide-name clefairy >data/pokeget/clefairy.txt
pokeget --hide-name ditto >data/pokeget/ditto.txt
pokeget --hide-name dratini >data/pokeget/dratini.txt
pokeget --hide-name eevee >data/pokeget/eevee.txt
pokeget --hide-name machoke >data/pokeget/machoke.txt
pokeget --hide-name pikachu >data/pokeget/pikachu.txt
pokeget --hide-name pikachu-world-cap >data/pokeget/pikachu-world-cap.txt
pokeget --hide-name psyduck >data/pokeget/psyduck.txt
pokeget --hide-name slowpoke >data/pokeget/slowpoke.txt
pokeget --hide-name squirtle >data/pokeget/squirtle.txt

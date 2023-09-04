#!/usr/bin/env bash

rustup update

cargo install \
	difftastic vivid \
	fnm stylua taplo-cli \
	pfetch pokeget

pokeget --hide-name pikachu >data/pokeget/pikachu.txt
pokeget --hide-name clefairy >data/pokeget/clefairy.txt
pokeget --hide-name ditto >data/pokeget/ditto.txt
pokeget --hide-name chikorita >data/pokeget/chikorita.txt

#!/usr/bin/env bash

rustup update

cargo install \
	difftastic vivid \
	fnm stylua taplo-cli \
	pfetch pokeget

pokeget pikachu >data/pokeget/pikachu.txt
pokeget clefairy >data/pokeget/clefairy.txt
pokeget ditto >data/pokeget/ditto.txt
pokeget chikorita >data/pokeget/chikorita.txt

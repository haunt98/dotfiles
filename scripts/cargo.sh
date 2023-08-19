#!/usr/bin/env bash

rustup update

cargo install \
	difftastic vivid \
	fnm stylua taplo-cli \
	pfetch pokeget

pokeget pikachu >data/pokeget/pikachu.txt

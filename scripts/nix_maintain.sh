#!/usr/bin/env bash

sudo -i sh -c 'nix-channel --update'
sudo -i sh -c 'nix-env -uA nixpkgs.nix'
sudo -i sh -c 'nix-collect-garbage -d'

nix-env -uA \
    nixpkgs.less nixpkgs.libgit2 nixpkgs.git nixpkgs.neovim \
    nixpkgs.fdupes nixpkgs.rsync nixpkgs.rclone nixpkgs.restic nixpkgs.taskwarrior \
    nixpkgs.nnn nixpkgs.ffmpegthumbnailer nixpkgs.asciinema-agg nixpkgs.yt-dlp nixpkgs.libjxl \
    nixpkgs.clang-tools nixpkgs.python3 nixpkgs.pipx nixpkgs.plantuml

nix-collect-garbage -d

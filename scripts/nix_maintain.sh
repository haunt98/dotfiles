#!/usr/bin/env bash

nix-channel --update

nix-env -uA \
    nixpkgs.less nixpkgs.libgit2 nixpkgs.git nixpkgs.neovim \
    nixpkgs.fdupes nixpkgs.rsync nixpkgs.rclone nixpkgs.restic nixpkgs.taskwarrior \
    nixpkgs.nnn nixpkgs.ffmpegthumbnailer nixpkgs.asciinema-agg nixpkgs.yt-dlp nixpkgs.libjxl \
    nixpkgs.clang-tools nixpkgs.python3 nixpkgs.pipx nixpkgs.plantuml

nix-collect-garbage -d

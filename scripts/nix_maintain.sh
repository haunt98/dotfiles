#!/usr/bin/env bash

sudo -i sh -c 'nix-channel --update --quiet'
sudo -i sh -c 'nix-env -uA nixpkgs.nix'
sudo -i sh -c 'nix-collect-garbage -d --quiet'

nix-env -uA \
    nixpkgs.less nixpkgs.curl \
    nixpkgs.git nixpkgs.neovim \
    nixpkgs.fdupes nixpkgs.rsync nixpkgs.rclone nixpkgs.restic nixpkgs.taskwarrior \
    nixpkgs.ffmpegthumbnailer nixpkgs.asciinema-agg nixpkgs.yt-dlp nixpkgs.libjxl nixpkgs.newsboat \
    nixpkgs.btop \
    nixpkgs.clang-tools nixpkgs.pipx nixpkgs.marksman nixpkgs.moar \
    nixpkgs.qmk

nix-collect-garbage -d --quiet

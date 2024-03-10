#!/usr/bin/env bash

sudo -i sh -c 'nix-channel --update --quiet'

nix-env -iA \
    nixpkgs.less nixpkgs.curl \
    nixpkgs.git nixpkgs.neovim \
    nixpkgs.fdupes nixpkgs.rsync nixpkgs.rclone nixpkgs.restic nixpkgs.taskwarrior \
    nixpkgs.ffmpegthumbnailer nixpkgs.asciinema-agg nixpkgs.yt-dlp nixpkgs.libjxl nixpkgs.newsboat \
    nixpkgs.btop nixpkgs.cpufetch nixpkgs.onefetch \
    nixpkgs.clang-tools nixpkgs.python3 nixpkgs.pipx nixpkgs.gh nixpkgs.moar \
    nixpkgs.qmk

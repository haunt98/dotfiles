#!/usr/bin/env bash

# https://nixos.org/manual/nix/stable/package-management/basic-package-mgmt
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --list
nix-channel --update

nix-env -iA \
    nixpkgs.git nixpkgs.neovim \
    nixpkgs.fdupes nixpkgs.rsync nixpkgs.rclone nixpkgs.restic nixpkgs.taskwarrior \
    nixpkgs.nnn nixpkgs.ffmpegthumbnailer nixpkgs.asciinema-agg nixpkgs.yt-dlp nixpkgs.libjxl \
    nixpkgs.pipx nixpkgs.plantuml

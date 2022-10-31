#!/usr/bin/env bash

# Aliases
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.cl clone
git config --global alias.co checkout
git config --global alias.df "diff -w"
git config --global alias.fe "fetch --all --tags"
git config --global alias.lg "log --stat"
git config --global alias.lg1 "log --oneline"
git config --global alias.pl "pull --tags"
git config --global alias.ps push
git config --global alias.st status
git config --global alias.sw switch
git config --global alias.tg "tag --sort=-version:refname"

# Misc
git config --global core.fsmonitor true
git config --global diff.colorMoved default
git config --global fetch.prune true
git config --global init.defaultBranch main
git config --global merge.conflictstyle diff3
git config --global pull.rebase true
git config --global pull.twohead ort
git config --global push.autoSetupRemote true

# Delta
# https://github.com/dandavison/delta
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global include.path "~/.config/delta/themes.gitconfig"
git config --global delta.features "chameleon"

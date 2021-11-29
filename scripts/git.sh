#!/usr/bin/env bash

# Aliases
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.cl clone
git config --global alias.co checkout
git config --global alias.df diff
git config --global alias.lg "log --stat"
git config --global alias.pl pull
git config --global alias.ps push
git config --global alias.st status
git config --global alias.sw switch
git config --global alias.tg "tag --sort=-version:refname"

# Misc
git config --global pull.rebase true
git config --global fetch.prune true
git config --global init.defaultBranch main

#!/usr/bin/env bash

# Clean state
truncate -s 0 ~/.gitconfig

# Global aliases
git config --global alias.ass add
git config --global alias.br branch
git config --global alias.brv "branch -v --sort=-committerdate"
git config --global alias.ci commit
git config --global alias.cl clone
git config --global alias.co checkout
git config --global alias.df "diff -w"
git config --global alias.dfc "diff -w --cached"
git config --global alias.fe "fetch --all --tags"
git config --global alias.lg "log --stat --abbrev-commit"
git config --global alias.lg1 "log --graph --abbrev-commit --pretty=format:'%Cred%h%Creset %C(yellow)%d%Creset %Cblue%an%Creset %s %Cgreen(%cr)%Creset'"
git config --global alias.me merge
git config --global alias.pl "pull --tags"
git config --global alias.ps push
git config --global alias.psa "!git remote | xargs -L1 -P8 git push"
git config --global alias.psaf "!git remote | xargs -L1 -P8 git push --force-with-lease"
git config --global alias.psf "push --force-with-lease"
git config --global alias.rank "shortlog -nse --no-merges"
git config --global alias.rst restore
git config --global alias.sh show
git config --global alias.st status
git config --global alias.stcl "stash clear"
git config --global alias.sth stash
git config --global alias.stp "stash pop"
git config --global alias.sw switch
git config --global alias.tg "tag --sort=-version:refname"

# Misc
git config --global commit.verbose true
git config --global core.excludesfile "~/.config/git/ignore"
git config --global core.fsmonitor true
git config --global diff.algorithm histogram
git config --global diff.colorMoved no
git config --global diff.submodule log
git config --global fetch.prune true
git config --global http.postBuffer 500000000
git config --global init.defaultBranch main
git config --global log.date iso
git config --global merge.conflictstyle zdiff3
git config --global pull.rebase false
git config --global pull.twohead ort
git config --global push.autoSetupRemote true
git config --global rebase.stat true
git config --global rerere.enabled true
git config --global status.submoduleSummary true
git config --global submodule.recurse true

# https://github.com/dandavison/delta
git config --global core.pager delta
git config --global delta.file-decoration-style none
git config --global delta.hunk-header-decoration-style none
git config --global delta.commit-decoration-style none
git config --global delta.navigate true

# https://github.com/catppuccin/delta
git config --global --add include.path "~/.config/delta/themes/catppuccin.gitconfig"
git config --global delta.features catppuccin-mocha
git config --global delta.catppuccin-mocha.file-decoration-style none
git config --global delta.catppuccin-mocha.hunk-header-decoration-style none
git config --global delta.catppuccin-mocha.commit-decoration-style none

# https://github.com/Wilfred/difftastic
git config --global alias.dftc "difftool --cached"
git config --global alias.dft "difftool"
git config --global diff.tool difftastic
git config --global difftool.difftastic.cmd 'difft "$LOCAL" "$REMOTE"'
git config --global difftool.prompt false
git config --global pager.difftool true

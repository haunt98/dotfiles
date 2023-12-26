#!/usr/bin/env bash

# Global aliases
git config --global alias.ass add
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.cl clone
git config --global alias.co checkout
git config --global alias.df "diff -w"
git config --global alias.dfc "diff -w --cached"
git config --global alias.fe "fetch --all --tags"
git config --global alias.lg "log --stat"
git config --global alias.lg1 "log --oneline"
git config --global alias.me merge
git config --global alias.pl "pull --tags"
git config --global alias.ps push
git config --global alias.psa "!git remote | xargs -L1 git push"
git config --global alias.psaf "!git remote | xargs -L1 git push --force-with-lease"
git config --global alias.psf "push --force-with-lease"
git config --global alias.rank "shortlog -nse --no-merges"
git config --global alias.sh show
git config --global alias.st status
git config --global alias.sw switch
git config --global alias.tg "tag --sort=-version:refname"

# Misc
git config --global core.fsmonitor true
git config --global diff.colorMoved no
git config --global fetch.prune true
git config --global init.defaultBranch main
git config --global merge.conflictstyle diff3
git config --global pull.rebase false
git config --global pull.twohead ort
git config --global push.autoSetupRemote true
git config --global rebase.stat true

# https://github.com/dandavison/delta
git config --global core.pager delta
git config --global delta.navigate true
git config --global delta.file-decoration-style none
git config --global delta.hunk-header-decoration-style none

# https://github.com/Wilfred/difftastic
git config --global diff.tool difftastic
git config --global difftool.prompt false
git config --global difftool.difftastic.cmd 'difft "$LOCAL" "$REMOTE"'
git config --global pager.difftool true
git config --global alias.dft "difftool"
git config --global alias.dfct "difftool --cached"

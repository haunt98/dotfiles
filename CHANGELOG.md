# CHANGELOG

## v0.8.0 (2021-11-19)

### Others

- chore: bump copy-go v0.8.0 (2021-11-19)

- chore(config): remove vim lang, should use IDE for that (2021-11-19)

- chore(config): return back Cascadia Code (2021-10-27)

- chore(config): back to Rec Mono Casual (2021-10-24)

- chore(config): remote truecolor and use onedark (2021-10-22)

- chore(config): remove coc.nvim (2021-10-12)

- chore(scripts): add git tag (2021-10-12)

- chore(config): Disable option in mac (2021-10-03)

- Bump terminal size to 14.0 (2021-09-24)

- chore(config): add tabstop for nvim (2021-09-24)

- chore(config): add fdignore (2021-09-18)

- chore(config): switch to nord config (2021-09-18)

- chore(config): use vim nord (2021-09-18)

- chore: Update configs (2021-09-17)

- chore: bump go 1.17 in github action (2021-08-19)

- build: update go.mod (2021-08-19)

- chore(config): remove unused exts nvim (2021-08-19)

- chore: add scripts folder (2021-08-14)

- chore(config): remove vim prettier (2021-08-07)

- build: update go.mod (2021-08-04)

- chore(config): add mouse support and add prettier (2021-08-04)

- chore(config): always love Agave (2021-07-16)

- chore(config): vim-go new default (2021-07-16)

- chore(config): remove nvim whitespace (2021-06-26)

- chore(nvim): strip whitespace (2021-06-24)

- chore(config): better tmux config (2021-06-24)

- chore(config): add tmux (2021-06-23)

- build: update go.mod (2021-06-17)

- build: update go.mod (2021-06-03)

- chore(config): update alacritty and nvim config (2021-06-03)

- build: update go.mod (2021-05-30)

- chore: remove already build (2021-05-24)

- chore(config): remove mpv (2021-05-24)

- chore(config): remove problematic (2021-05-16)

- chore(config): add mpv (2021-05-16)

- chore(config): re add bat (2021-05-13)

- chore(changelog): generate v0.7.0 (2021-05-05)

## v0.7.0 (2021-05-05)

### Added

- feat: un-export action funcs (2021-05-05)

- feat: do not distinguish errors for simple case (2021-05-05)

- feat: add compare command (#10) (2021-04-23)

- feat: dry run for install, update, clean (#9) (2021-04-22)

- feat: treat files, dirs in config as the same (#8) (2021-04-22)

- feat: add --dry-run flag (#6) (2021-04-22)

- feat: add --verbose flag (#5) (2021-04-15)

### Fixed

- fix: correct aliases for commands (2021-04-14)

### Others

- chore(readme): use dot as new name (2021-05-05)

- chore: no need to have separate getConfigPath (2021-05-05)

- refactor: split config real and config demo (2021-05-05)

- chore: correct go build in github action (2021-05-05)

- refactor: remove unused struct (2021-05-05)

- refactor: move main to cmd (2021-05-05)

- chore:  switch pkg to internal (2021-05-05)

- chore: add building macos on github action (#11) (2021-04-23)

- chore(readme): guide compare (2021-04-23)

- refactor: move completely cli outside golang (#7) (2021-04-22)

- chore(config): use tag vim-go release (2021-04-19)

- chore(config): ignore vim-go version (2021-04-16)

- refactor: move aliases to pre-define var (2021-04-14)

- chore(changelog): generate v0.6.0 (2021-04-14)

## v0.6.0 (2021-4-14)

### Added

- feat: use my own color pkg to wrap fatih/color (#3)

- feat: prevent define os running at runtime (#2)

### Others

- chore: only run github action on main or pull request (#4)

- chore(config): split vim and neovim config, keep it the same for now

- chore(confg): add vimrc

- build: update go.mod

- chore: update latest go in github action

- chore(config): i3status onedark color

- chore(config): use lightline instead of airline

- chore(config): add fcitx

- chore(config): add redshift

- chore(config): aadjust brightness in i3

- chore(config): i3lock with black color

- chore(config): add feh and update rofi

- chore(config): simplify i3

- chore(config): add volume i3status

- chore(config): better i3status

- chore(config): add xinit

- chore(config): use cascadia code to look good on my bad laptop

- chore(config): add rofi config

- chore(config): add i3status config

- chore(config): add i3 config

- chore(config): use TwoDark for bat

- chore(config): remove neovim solarized

- chore(config): add one-dark color for alacritty

- chore(config): add alacritty config

- chore(config): stricter go format

- chore(config): use airline for neovim

- chore(config): disable cursor style in neovim

- chore(config): switch neovim to onedark

- chore(config): add onedark to vim

- chore(config): tmux painless config

- chore(config): better comment config neovim

- chore(config): tmux plugin manager

- chore(config): use back C-b for tmux

- chore(changelog): generate v0.5.0

## v0.5.0 (2021-3-17)

### Added

- feat: replace ioutil.ReadAll with os pkg

### Others

- build: bump copy-go v0.4.0

- chore(changelog): generate v0.4.0

## v0.4.0 (2021-3-17)

### Others

- chore(readme): better install usage

- chore: bump go 1.16 in github action

- build: bump go 1.16

- chore(config): update nvim

- build: update go.mod

- build: update go.mod

- chore: remove old install script

- chore(configs): add vim-polygot

- chore(config): good old goimports

- chore: use bat solarized

- chore: update nvim config

- chore: update nvim, tmux; remove fontconfig

- chore: ignore .bak files

- chore: remove fish config

- chore: add fish config

- chore: ignore node package.json

- chore(nvim): ignore vim-go warning

- build: update go.mod

- chore(changelog): generate v0.3.0

## v0.3.0 (2021-1-20)

### Added

- feat(config): safe to delete unusedApps directly

- feat(config): config clean remove all unused apps

- feat: add clean config skeleton

- feat: add skeleton clean command

### Others

- refactor: use copier instead copy

- refactor: move fmtErr to global var

- chore: typo currentDir

- chore(config): use Choco cooky font

- refactor: use replaceFile and replaceDir

- chore: remove github super linter

- chore(changelog): generate v0.2.0

## v0.2.0 (2021-1-18)

### Added

- feat(config): replace configs path to config

- feat: remove config path completly

- feat: revert use absolute path to copy configs

- feat: remove path flags

- feat: use absolute path to copy configs

- feat: add update cmd

- feat: add update config

- feat: add install config using my own copy pkg

- feat(config): split files and folders

- feat: add config loading

- feat: skeleton install, update command

- feat: skeleton go cli app

### Fixed

- fix(config): correct copy dir

### Others

- chore: add bat config

- chore: cleanup unused config

- build: bumpd copy-go v0.3.0

- chore: remove unused file

- chore(readme): correct github linter badge

- chore(readme): add github badges

- chore: add golang in github action

- chore(readme): add guide

- chore: update from my config

- chore: ignore build file

- chore(config): add stackoverflow comments

- refactor: use remove and copy to reduce boiler plate code

- build: bump copy-go v0.2.0

- chore: update configs

- chore: add gitignore

- chore: add github action linter

- chore: add MIT LICENSE

- chore(changelog): generate v0.1.0

## v0.1.0 (2021-1-12)

### Others

- chore: add comment to install.sh

- better nvim defaults

- use env bash

- remove bat

- remove mpv as use other frontend

- zenburn

- remove terminal, use default as much as possible

- tmux 3.1 move config to XDG

- how to install

- README

- enough

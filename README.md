# Dotfiles

[![Go](https://github.com/haunt98/dotfiles/workflows/Go/badge.svg?branch=main)](https://github.com/haunt98/dotfiles/actions)

## Usage

```sh
# Build
go build ./cmd/dot

# Install dotfiles
./dot install

# Update dotfiles with user config
./dot update

# Compare dotfiles with user config
./dot compare
```

## Roadmap

- [x] Switch to use lua for neovim config
- [x] Add diff command
- [x] Support diff directory
- [ ] Support embed confgis
- [ ] Release single binary

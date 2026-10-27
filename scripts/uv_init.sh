#!/usr/bin/env bash

uv tool update-shell

# uv tool uninstall --all
uv tool install ruff
uv tool install ty
uv tool install keymap-drawer

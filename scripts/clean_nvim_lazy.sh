#!/usr/bin/env bash

set -euo pipefail

LAZY_DIR="${HOME}/.local/share/nvim/lazy"

if [[ ! -d $LAZY_DIR ]]; then
    echo "$LAZY_DIR not exist"
    exit 1
fi

for dir in "$LAZY_DIR"/*/; do
    if [[ -d $dir && -d "${dir}.git" ]]; then
        plugin_name=$(basename "$dir")
        echo "Clean $plugin_name"

        git -C "$dir" clean -dfx
        git -C "$dir" -c gc.repackFilter="blob:none" gc --prune=now
    fi
done

# Need to run this once in a while
# go clean -cache -testcache -modcache -fuzzcache
# golangci-lint cache clean
# docker system prune --all --force --volumes
# uv cache clean
# npm cache clean --force
# truncate -s 0 ~/.local/state/nvim/log
# truncate -s 0 ~/.local/state/nvim/lsp.log
# truncate -s 0 ~/.local/state/nvim/nvim.log
# rm -rf ~/.config/opencode/logs/*
# rm -rf ~/.local/share/opencode/log/*
#
# macOS
# rm -rf ~/Library/Caches/gopls
# rm -rf ~/Library/Caches/goimports
# rm -rf ~/Library/Logs/DiagnosticReports/*
# rm -rf ~/Library/Logs/Homebrew/*
# rm -rf ~/Library/Logs/Zed/*
# rm -rf ~/Library/Logs/JetBrains/*
# rm -rf ~/Library/Logs/HTTPie/*
# rm -rf ~/Library/Logs/Microsoft/*
# rm -rf ~/Library/Logs/Cloudflare/*
# sudo log erase --all
# sudo rm /private/var/log/system.log.*.gz
# sudo rm /private/var/log/install.log.*.gz
# sudo rm /private/var/log/wifi.log.*.bz2
# sudo truncate -s 0 /private/var/log/ovpnagent.log

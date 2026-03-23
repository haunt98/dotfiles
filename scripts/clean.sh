# Need to run this once in a while
# go clean -cache -testcache -modcache -fuzzcache
# golangci-lint cache clean
# docker system prune --all --force --volumes
# uv cache clean
# rm -rf ~/.bun/install/cache
# truncate -s 0 ~/.local/state/nvim/log
# truncate -s 0 ~/.local/state/nvim/lsp.log
#
# macOS
# rm -rf ~/Library/Caches/gopls
# rm -rf ~/Library/Caches/goimports
# sudo log erase --all
# sudo rm /private/var/log/system.log.*.gz
# sudo rm /private/var/log/install.log.*.gz
# sudo rm /private/var/log/wifi.log.*.bz2
# sudo truncate -s 0 /private/var/log/ovpnagent.log

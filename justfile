all: tidy format test-color lint build clean

tidy:
    go mod tidy

test:
    go test -race -failfast ./...

test-color:
    # go install github.com/haunt98/go-test-color@latest
    go-test-color -race -failfast ./...

coverage:
    go test -coverprofile=coverage.out ./...

coverage-cli: coverage
    go tool cover -func=coverage.out

coverage-html: coverage
    go tool cover -html=coverage.out

lint:
    golangci-lint run --fix ./...
    modernize -fix -test ./...

format:
    # go install github.com/haunt98/gofimports/cmd/gofimports@latest
    gofimports -w --company github.com/make-go-great,github.com/haunt98 .
    gofumpt -w -extra .
    shfmt -w -s -i 4 ./scripts \
        ./data/zsh/top-zshrc \
        ./data/zsh/bottom-zshrc

build:
    go build ./cmd/dot

clean:
    rm -rf dot

upstream:
    wcurl --curl-options="--clobber --netrc" "https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/refs/heads/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh" --output ./data/zsh/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
    wcurl --curl-options="--clobber --netrc" "https://raw.githubusercontent.com/catppuccin/kitty/main/themes/mocha.conf" --output ./data/kitty/mocha.conf
    # wcurl --curl-options="--clobber --netrc" "https://github.com/DinkDonk/kitty-icon/raw/refs/heads/main/kitty-dark.icns" --output ./data/kitty/kitty-dark.icns
    # wcurl --curl-options="--clobber --netrc" "https://github.com/DinkDonk/kitty-icon/raw/refs/heads/main/kitty-light.icns" --output ./data/kitty/kitty-light.icns
    wcurl --curl-options="--clobber --netrc" "https://raw.githubusercontent.com/catppuccin/ghostty/refs/heads/main/themes/catppuccin-mocha.conf" --output ./data/ghostty/catppuccin-mocha.conf
    wcurl --curl-options="--clobber --netrc" "https://raw.githubusercontent.com/catppuccin/delta/main/catppuccin.gitconfig" --output ./data/delta/themes/catppuccin.gitconfig

dot-upd:
    go run ./cmd/dot upd

dot-ins:
    go run ./cmd/dot ins

dot-df:
    go run ./cmd/dot df

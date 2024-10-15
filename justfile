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
    golangci-lint run ./...

format:
    # go install github.com/haunt98/gofimports/cmd/gofimports@latest
    # go install mvdan.cc/gofumpt@latest
    # go install mvdan.cc/sh/v3/cmd/shfmt@latest
    gofimports -w --company github.com/make-go-great,github.com/haunt98 .
    gofumpt -w -extra .
    shfmt -w -s -i 4 ./scripts ./data/zsh

build:
    go build ./cmd/dot

clean:
    rm -rf dot

dot-upd:
    go run ./cmd/dot upd

dot-ins:
    go run ./cmd/dot ins

dot-dl:
    go run ./cmd/dot dl

dot-df:
    go run ./cmd/dot df

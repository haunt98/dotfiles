.PHONY: all test test-color coverage coverage-cli coverate-html lint format build

all: test-color lint format
	go mod tidy

test:
	go test -race -failfast ./...

test-color:
	go install github.com/haunt98/go-test-color@latest
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
	go install github.com/haunt98/gofimports/cmd/gofimports@latest
	go install mvdan.cc/gofumpt@latest
	go install mvdan.cc/sh/v3/cmd/shfmt@latest
	gofimports -w -company github.com/make-go-great .
	gofumpt -w -extra .
	shfmt -w ./scripts

build:
	go build ./cmd/dot

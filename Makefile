.PHONY: all test lint

all: test lint

test:
	go test -race -failfast ./...

lint:
	golangci-lint run ./...

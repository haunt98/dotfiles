#!/usr/bin/env bash

go install github.com/ayoisaiah/f2/cmd/f2@latest

go install mvdan.cc/sh/v3/cmd/shfmt@latest

go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest

go install github.com/mikefarah/yq/v4@latest
go install github.com/itchyny/gojq/cmd/gojq@latest
go install github.com/antonmedv/fx@latest

go install golang.org/x/telemetry/cmd/gotelemetry@latest
gotelemetry on

go install golang.org/x/vuln/cmd/govulncheck@latest
go install golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment@latest

go install mvdan.cc/gofumpt@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/maruel/panicparse/v2@latest
go install gotest.tools/gotestsum@latest
go install github.com/bufbuild/buf/cmd/buf@v1.31.0

# Need to run this once a month
# go clean -cache -testcache -modcache -fuzzcache

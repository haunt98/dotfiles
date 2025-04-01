#!/usr/bin/env bash

go install mvdan.cc/sh/v3/cmd/shfmt@latest

go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment@latest
go install golang.org/x/tools/gopls/internal/analysis/modernize/cmd/modernize@latest
go install golang.org/x/tools/gopls@latest
go install golang.org/x/vuln/cmd/govulncheck@latest

go install golang.org/x/telemetry/cmd/gotelemetry@latest
gotelemetry on

go install github.com/walles/moar@latest

go install mvdan.cc/gofumpt@latest
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
go install github.com/dkorunic/betteralign/cmd/betteralign@latest
go install gotest.tools/gotestsum@latest
go install github.com/bufbuild/buf/cmd/buf@latest
go install github.com/google/pprof@latest
go install github.com/sudorandom/fauxrpc/cmd/fauxrpc@latest

#!/usr/bin/env bash

go install mvdan.cc/sh/v3/cmd/shfmt@latest

go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls/internal/analysis/modernize/cmd/modernize@latest
go install golang.org/x/tools/gopls@latest

go install golang.org/x/telemetry/cmd/gotelemetry@latest
gotelemetry on

go install github.com/walles/moar@latest

go install mvdan.cc/gofumpt@latest
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
go install github.com/bufbuild/buf/cmd/buf@latest

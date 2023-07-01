#!/usr/bin/env bash

go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install golang.org/x/tools/gopls@latest
go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
go install mvdan.cc/gofumpt@latest
go install golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment@latest
go install gotest.tools/gotestsum@latest

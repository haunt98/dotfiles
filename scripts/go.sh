#!/usr/bin/env bash

go install github.com/ayoisaiah/f2/cmd/f2@latest
go install github.com/dundee/gdu/v5/cmd/gdu@latest
go install github.com/muesli/duf@latest
go install github.com/charmbracelet/glow@latest

go install mvdan.cc/sh/v3/cmd/shfmt@latest

go install golang.org/x/tools/gopls@latest

go install github.com/mikefarah/yq/v4@latest
go install github.com/itchyny/gojq/cmd/gojq@latest
go install github.com/antonmedv/fx@latest

go install mvdan.cc/gofumpt@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment@latest
go install github.com/dkorunic/betteralign/cmd/betteralign@latest
go install gotest.tools/gotestsum@latest
go install github.com/maruel/panicparse/v2@latest

go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest

package main

import (
	"fmt"
	"os"
	"os/user"
	"path/filepath"

	copier "github.com/haunt98/copy-go"
)

const (
	homeSymbol = '~'
)

type copyFn func(from, to string) error

func replaceFile(from, to string) error {
	return replace(from, to, copier.CopyFile)
}

func replaceDir(from, to string) error {
	return replace(from, to, copier.CopyDir)
}

func replace(from, to string, fn copyFn) error {
	newFrom, err := replaceHomeSymbol(from)
	if err != nil {
		return fmt.Errorf("failed to replace home symbol %s: %w", from, err)
	}

	newTo, err := replaceHomeSymbol(to)
	if err != nil {
		return fmt.Errorf("failed to replace home symbol %s: %w", to, err)
	}

	if err := os.RemoveAll(newTo); err != nil {
		return fmt.Errorf("failed to remove %s: %w", newTo, err)
	}

	if err := fn(newFrom, newTo); err != nil {
		return fmt.Errorf("failed to copy from %s to %s: %w", newFrom, newTo, err)
	}

	return nil
}

// replace ~
// https://stackoverflow.com/a/17609894
func replaceHomeSymbol(path string) (string, error) {
	if path == "" || path[0] != homeSymbol {
		return path, nil
	}

	currentUser, err := user.Current()
	if err != nil {
		return "", err
	}

	newPath := filepath.Join(currentUser.HomeDir, path[1:])
	return newPath, nil
}

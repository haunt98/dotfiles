package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"os/user"
	"path/filepath"

	"github.com/haunt98/copy-go"
)

const (
	homeSymbol = '~'
)

type Config struct {
	// Read from file
	Apps map[string]App `json:"apps"`
}

type App struct {
	Files []Path `json:"files"`
	Dirs  []Path `json:"dirs"`
}

type Path struct {
	Internal string `json:"internal"`
	External string `json:"external"`
}

type copyFn func(from, to string) error

// Load config from file
func LoadConfig(path string) (result Config, err error) {
	configPath := getConfigPath(path)
	f, err := os.Open(configPath)
	if err != nil {
		// https://github.com/golang/go/blob/3e1e13ce6d1271f49f3d8ee359689145a6995bad/src/os/error.go#L90-L91
		if errors.Is(err, os.ErrNotExist) {
			err = fmt.Errorf("file not exist %s: %w", configPath, err)
			return
		}
	}
	defer f.Close()

	bytes, err := ioutil.ReadAll(f)
	if err != nil {
		err = fmt.Errorf("failed to read %s: %w", configPath, err)
		return
	}

	if err = json.Unmarshal(bytes, &result); err != nil {
		err = fmt.Errorf("failed to unmarshal: %w", err)
		return
	}

	return
}

// internal -> external
func (c *Config) Install() error {
	for _, app := range c.Apps {
		for _, file := range app.Files {
			if err := removeAndCopy(file.Internal, file.External, copy.CopyFile); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", file.Internal, file.External)
			}
		}

		for _, dir := range app.Dirs {
			if err := removeAndCopy(dir.Internal, dir.External, copy.CopyFile); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", dir.Internal, dir.External)
			}
		}
	}

	return nil
}

// external -> internal
func (c *Config) Update() error {
	for _, app := range c.Apps {
		for _, file := range app.Files {
			if err := removeAndCopy(file.External, file.Internal, copy.CopyFile); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", file.External, file.Internal)
			}
		}

		for _, dir := range app.Dirs {
			if err := removeAndCopy(dir.External, dir.Internal, copy.CopyFile); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", dir.External, dir.Internal)
			}
		}
	}

	return nil
}

func getConfigPath(path string) string {
	return filepath.Join(path, "configs/config.json")
}

func removeAndCopy(from, to string, fn copyFn) error {
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

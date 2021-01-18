package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/haunt98/copy-go"
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
			if err := os.RemoveAll(file.External); err != nil {
				return fmt.Errorf("failed to remove %s: %w", file.External, err)
			}

			if err := copy.CopyFile(file.Internal, file.External); err != nil {
				return fmt.Errorf("failed to copy from %s to %s: %w", file.Internal, file.External, err)
			}
		}

		for _, dir := range app.Dirs {
			if err := os.RemoveAll(dir.External); err != nil {
				return fmt.Errorf("failed to remove %s: %w", dir.External, err)
			}

			if err := copy.CopyDir(dir.Internal, dir.External); err != nil {
				return fmt.Errorf("failed to copy from %s to %s: %w", dir.Internal, dir.External, err)
			}
		}
	}

	return nil
}

// external -> internal
func (c *Config) Update() error {
	for _, app := range c.Apps {
		for _, file := range app.Files {
			if err := os.RemoveAll(file.Internal); err != nil {
				return fmt.Errorf("failed to remove %s: %w", file.Internal, err)
			}

			if err := copy.CopyFile(file.External, file.Internal); err != nil {
				return fmt.Errorf("failed to copy from %s to %s: %w", file.External, file.Internal, err)
			}
		}

		for _, dir := range app.Dirs {
			if err := os.RemoveAll(dir.Internal); err != nil {
				return fmt.Errorf("failed to remove %s: %w", dir.Internal, err)
			}

			if err := copy.CopyDir(dir.External, dir.Internal); err != nil {
				return fmt.Errorf("failed to copy from %s to %s: %w", dir.External, dir.Internal, err)
			}
		}
	}

	return nil
}

func getConfigPath(path string) string {
	return filepath.Join(path, "configs/config.json")
}

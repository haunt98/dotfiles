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
	// Read when run
	Path string `json:"-"`

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

	result.Path = configPath
	return
}

// internal -> external
func (c *Config) Install() error {
	for _, app := range c.Apps {
		for _, file := range app.Files {
			internal := filepath.Join(c.Path, file.Internal)
			internal, err := filepath.Abs(internal)
			if err != nil {
				return fmt.Errorf("failed to abs path %s: %w", internal, err)
			}

			external, err := filepath.Abs(file.External)
			if err != nil {
				return fmt.Errorf("failed to abs path %s: %w", external, err)
			}

			if err := os.RemoveAll(external); err != nil {
				return fmt.Errorf("failed to remove %s: %w", external, err)
			}

			if err := copy.CopyFile(internal, external); err != nil {
				return fmt.Errorf("failed to copy from %s to %s: %w", internal, external, err)
			}
		}

		for _, dir := range app.Dirs {
			internal := filepath.Join(c.Path, dir.Internal)
			internal, err := filepath.Abs(internal)
			if err != nil {
				return fmt.Errorf("failed to abs path %s: %w", internal, err)
			}

			external, err := filepath.Abs(dir.External)
			if err != nil {
				return fmt.Errorf("failed to abs path %s: %w", external, err)
			}

			if err := os.RemoveAll(external); err != nil {
				return fmt.Errorf("failed to remove %s: %w", external, err)
			}

			if err := copy.CopyDir(internal, external); err != nil {
				return fmt.Errorf("failed to copy from %s to %s: %w", internal, external, err)
			}
		}
	}

	return nil
}

// external -> internal
func (c *Config) Update() error {
	for _, app := range c.Apps {
		for _, file := range app.Files {
			internal := filepath.Join(c.Path, file.Internal)
			internal, err := filepath.Abs(internal)
			if err != nil {
				return fmt.Errorf("failed to abs path %s: %w", internal, err)
			}

			external, err := filepath.Abs(file.External)
			if err != nil {
				return fmt.Errorf("failed to abs path %s: %w", external, err)
			}

			if err := os.RemoveAll(internal); err != nil {
				return fmt.Errorf("failed to remove %s: %w", internal, err)
			}

			if err := copy.CopyFile(external, internal); err != nil {
				return fmt.Errorf("failed to copy from %s to %s: %w", external, internal, err)
			}
		}

		for _, dir := range app.Dirs {
			internal := filepath.Join(c.Path, dir.Internal)
			internal, err := filepath.Abs(internal)
			if err != nil {
				return fmt.Errorf("failed to abs path %s: %w", internal, err)
			}

			external, err := filepath.Abs(dir.External)
			if err != nil {
				return fmt.Errorf("failed to abs path %s: %w", external, err)
			}

			if err := os.RemoveAll(internal); err != nil {
				return fmt.Errorf("failed to remove %s: %w", internal, err)
			}

			if err := copy.CopyDir(external, internal); err != nil {
				return fmt.Errorf("failed to copy from %s to %s: %w", external, internal, err)
			}
		}
	}

	return nil
}

func getConfigPath(path string) string {
	return filepath.Join(path, "configs/config.json")
}

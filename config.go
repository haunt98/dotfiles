package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"

	"github.com/haunt98/copy-go"
)

const (
	configDirPath = "config"
	configFile    = "config.json"
)

type Config interface {
	Install() error
	Update() error
	Clearn() error
}

type config struct {
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
func LoadConfig(path string) (*config, error) {
	configPath := getConfigPath(path)
	bytes, err := os.ReadFile(configPath)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return nil, fmt.Errorf("file not exist %s: %w", configPath, err)
		}

		return nil, fmt.Errorf("failed to read file%s: %w", configPath, err)
	}

	var c config
	if err = json.Unmarshal(bytes, &c); err != nil {
		return nil, fmt.Errorf("failed to unmarshal: %w", err)
	}

	return &c, nil
}

// internal -> external
func (c *config) Install() error {
	for _, app := range c.Apps {
		for _, file := range app.Files {
			if err := copy.Replace(file.Internal, file.External); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", file.Internal, file.External, err)
			}
		}

		for _, dir := range app.Dirs {
			if err := copy.Replace(dir.Internal, dir.External); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", dir.Internal, dir.External, err)
			}
		}
	}

	return nil
}

// external -> internal
func (c *config) Update() error {
	for _, app := range c.Apps {
		for _, file := range app.Files {
			if err := copy.Replace(file.External, file.Internal); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", file.External, file.Internal, err)
			}
		}

		for _, dir := range app.Dirs {
			if err := copy.Replace(dir.External, dir.Internal); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", dir.External, dir.Internal, err)
			}
		}
	}

	return nil
}

func (c *config) Clean() error {
	files, err := os.ReadDir(configDirPath)
	if err != nil {
		return fmt.Errorf("failed to read dir %s: %w", configDirPath, err)
	}

	// get all dirs inside config dir
	unusedDirs := make(map[string]struct{})
	for _, file := range files {
		if file.Name() == configFile {
			continue
		}

		unusedDirs[file.Name()] = struct{}{}
	}

	// removed used dirs
	for name := range c.Apps {
		delete(unusedDirs, name)
	}

	// delete ununsed dirs to save some space
	for dir := range unusedDirs {
		dirPath := filepath.Join(configDirPath, dir)
		if err := os.RemoveAll(dirPath); err != nil {
			return fmt.Errorf("failed to remove %s: %w", dir, err)
		}
	}

	return nil
}

func getConfigPath(path string) string {
	return filepath.Join(path, configDirPath, configFile)
}

package config

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"

	"github.com/haunt98/copy-go"
)

const (
	configDirPath = "data"
	configFile    = "data.json"
)

type config struct {
	configApps
}

var _ Config = (*config)(nil)

type configApps struct {
	Apps map[string]App `json:"apps"`
}

// Read from file
type App struct {
	Paths []Path `json:"paths"`
}

type Path struct {
	Internal string `json:"internal"`
	External string `json:"external"`
}

// LoadConfig return config, configDemo
func LoadConfig(path string) (*config, *configDemo, error) {
	configPath := getConfigPath(path)
	bytes, err := os.ReadFile(configPath)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return nil, nil, fmt.Errorf("file not exist %s: %w", configPath, err)
		}

		return nil, nil, fmt.Errorf("failed to read file%s: %w", configPath, err)
	}

	var cfgApps configApps
	if err = json.Unmarshal(bytes, &cfgApps); err != nil {
		return nil, nil, fmt.Errorf("failed to unmarshal: %w", err)
	}

	cfg := config{
		configApps: cfgApps,
	}

	cfgDemo := configDemo{
		configApps: cfgApps,
	}

	return &cfg, &cfgDemo, nil
}

// Install replace src internal dst external
func (c *config) Install() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if err := copy.Replace(p.Internal, p.External); err != nil {
				return fmt.Errorf("failed to replace src %s dst %s: %w", p.Internal, p.External, err)
			}
		}
	}

	return nil
}

// Update replace src external dst internal
func (c *config) Update() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if err := copy.Replace(p.External, p.Internal); err != nil {
				return fmt.Errorf("failed to replace src %s dst %s: %w", p.External, p.Internal, err)
			}
		}
	}

	return nil
}

// Clean remove unused config inside config dir
func (c *config) Clean() error {
	files, err := os.ReadDir(configDirPath)
	if err != nil {
		return fmt.Errorf("failed to read dir %s: %w", configDirPath, err)
	}

	// Get all dirs inside config dir
	unusedDirs := make(map[string]struct{})
	for _, file := range files {
		// Ignore config file
		if file.Name() == configFile {
			continue
		}

		unusedDirs[file.Name()] = struct{}{}
	}

	// Removed used dirs
	for name := range c.Apps {
		delete(unusedDirs, name)
	}

	// Delete ununsed dirs to save some space
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

package config

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

const (
	configDirPath = "data"
	configFile    = "data.json"
)

type Config interface {
	Install() error
	Update() error
	Clean() error
	Diff() error
}

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
func LoadConfig(path string) (*configReal, *configDemo, error) {
	configPath := filepath.Join(path, configDirPath, configFile)
	bytes, err := os.ReadFile(configPath)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to read file%s: %w", configPath, err)
	}

	var cfgApps configApps
	if err = json.Unmarshal(bytes, &cfgApps); err != nil {
		return nil, nil, fmt.Errorf("failed to unmarshal: %w", err)
	}

	cfgReal := configReal{
		configApps: cfgApps,
	}

	cfgDemo := configDemo{
		configApps: cfgApps,
	}

	return &cfgReal, &cfgDemo, nil
}

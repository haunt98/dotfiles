package config

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"time"
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
	Download() error
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
	External string `json:"external,omitempty"`
	URL      string `json:"url,omitempty"`
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
		httpClient: &http.Client{
			Timeout: time.Second * 5,
		},
		configApps: cfgApps,
	}

	cfgDemo := configDemo{
		configApps: cfgApps,
	}

	return &cfgReal, &cfgDemo, nil
}

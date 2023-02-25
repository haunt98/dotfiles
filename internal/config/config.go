package config

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"time"

	"github.com/BurntSushi/toml"
)

const (
	configDirPath  = "data"
	configFileJSON = "data.json"
	configFileTOML = "data.toml"
)

var ErrConfigNotFound = errors.New("config not found")

type Config interface {
	Install() error
	Update() error
	Clean() error
	Diff() error
	Download() error
	Validate() error
}

type ConfigApps struct {
	Apps map[string]App `json:"apps" toml:"apps"`
}

// Read from file
type App struct {
	Paths []Path `json:"paths" toml:"paths"`
}

type Path struct {
	Internal string `json:"internal" toml:"internal"`
	External string `json:"external,omitempty" toml:"external"`
	URL      string `json:"url,omitempty" toml:"url"`
}

// LoadConfig return config, configDemo
func LoadConfig(path string) (*configReal, *configDemo, error) {
	cfgReal, cfgDemo, err := loadConfigJSON(path)
	if err == nil {
		return cfgReal, cfgDemo, nil
	}

	cfgReal, cfgDemo, err = loadConfigTOML(path)
	if err == nil {
		return cfgReal, cfgDemo, nil
	}

	return nil, nil, ErrConfigNotFound
}

func loadConfigJSON(path string) (*configReal, *configDemo, error) {
	configPathJSON := filepath.Join(path, configDirPath, configFileJSON)

	bytes, err := os.ReadFile(configPathJSON)
	if err != nil {
		return nil, nil, fmt.Errorf("os: failed to read file [%s]: %w", configPathJSON, err)
	}

	var cfgApps ConfigApps
	if err = json.Unmarshal(bytes, &cfgApps); err != nil {
		return nil, nil, fmt.Errorf("json: failed to unmarshal: %w", err)
	}

	cfgReal := configReal{
		httpClient: &http.Client{
			Timeout: time.Second * 5,
		},
		ConfigApps: cfgApps,
	}

	cfgDemo := configDemo{
		ConfigApps: cfgApps,
	}

	return &cfgReal, &cfgDemo, nil
}

func loadConfigTOML(path string) (*configReal, *configDemo, error) {
	configPathTOML := filepath.Join(path, configDirPath, configFileTOML)

	bytes, err := os.ReadFile(configPathTOML)
	if err != nil {
		return nil, nil, fmt.Errorf("os: failed to read file [%s]: %w", configPathTOML, err)
	}

	var cfgApps ConfigApps
	if err := toml.Unmarshal(bytes, &cfgApps); err != nil {
		return nil, nil, fmt.Errorf("toml: failed to decode: %w", err)
	}

	cfgReal := configReal{
		httpClient: &http.Client{
			Timeout: time.Second * 5,
		},
		ConfigApps: cfgApps,
	}

	cfgDemo := configDemo{
		ConfigApps: cfgApps,
	}

	return &cfgReal, &cfgDemo, nil
}

package config

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"

	"github.com/BurntSushi/toml"
)

const (
	configDirPath  = "data"
	configFileJSON = "data.json"
	configFileTOML = "data.toml"
)

var ErrConfigNotFound = errors.New("config not found")

type Config interface {
	Install(appNames ...string) error
	Update(appNames ...string) error
	Clean() error
	Diff(appNames ...string) error
	Download(appNames ...string) error
	Validate(appNames ...string) error
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
func LoadConfig(path string) (*ConfigReal, *ConfigDemo, error) {
	configPathJSON := filepath.Join(path, configDirPath, configFileJSON)
	bytes, err := os.ReadFile(configPathJSON)
	if err == nil {
		return loadConfig(bytes, json.Unmarshal)
	}

	configPathTOML := filepath.Join(path, configDirPath, configFileTOML)
	bytes, err = os.ReadFile(configPathTOML)
	if err == nil {
		return loadConfig(bytes, toml.Unmarshal)
	}

	return nil, nil, ErrConfigNotFound
}

func loadConfig(bytes []byte, unmarshalFn func(data []byte, v any) error) (*ConfigReal, *ConfigDemo, error) {
	var cfgApps ConfigApps
	if err := unmarshalFn(bytes, &cfgApps); err != nil {
		return nil, nil, fmt.Errorf("failed to unmarshal: %w", err)
	}

	cfgReal := ConfigReal{
		ConfigApps: cfgApps,
	}

	cfgDemo := ConfigDemo{
		ConfigApps: cfgApps,
	}

	return &cfgReal, &cfgDemo, nil
}

// Helper
func slice2map(vs []string) map[string]struct{} {
	m := make(map[string]struct{}, len(vs))
	for _, v := range vs {
		m[v] = struct{}{}
	}
	return m
}

package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
)

type Config struct {
	Apps map[string]App `json:"apps"`
}

type App struct {
	ConfigPath string `json:"config_path"`
}

// Load config from file
func LoadConfig(path string) (Config, error) {
	configPath := getConfigPath(path)
	f, err := os.Open(configPath)
	if err != nil {
		// https://github.com/golang/go/blob/3e1e13ce6d1271f49f3d8ee359689145a6995bad/src/os/error.go#L90-L91
		if errors.Is(err, os.ErrNotExist) {
			return Config{}, fmt.Errorf("file not exist %s: %w", configPath, err)
		}
	}
	defer f.Close()

	bytes, err := ioutil.ReadAll(f)
	if err != nil {
		return Config{}, fmt.Errorf("failed to read %s: %w", configPath, err)
	}

	var result Config
	if err := json.Unmarshal(bytes, &result); err != nil {
		return Config{}, fmt.Errorf("failed to unmarshal: %w,", err)
	}

	return result, nil
}

func getConfigPath(path string) string {
	return filepath.Join(path, "configs/config.json")
}

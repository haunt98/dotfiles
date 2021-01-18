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
	// Read when run
	Path string `json:"-"`

	// Read from file
	Apps map[string]App `json:"apps"`
}

type App struct {
	Files   []FromToPath `json:"files"`
	Folders []FromToPath `json:"folders"`
}

type FromToPath struct {
	From string `json:"from"`
	To   string `json:"to"`
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

	if err := json.Unmarshal(bytes, &result); err != nil {
		err = fmt.Errorf("failed to unmarshal: %w", err)
		return
	}

	result.Path = configPath
	return
}

func getConfigPath(path string) string {
	return filepath.Join(path, "configs/config.json")
}

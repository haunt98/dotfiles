package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
)

const (
	configDirPath = "config"
	configFile    = "config.json"
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
			if err := replaceFile(file.Internal, file.External); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", file.Internal, file.External, err)
			}
		}

		for _, dir := range app.Dirs {
			if err := replaceDir(dir.Internal, dir.External); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", dir.Internal, dir.External, err)
			}
		}
	}

	return nil
}

// external -> internal
func (c *Config) Update() error {
	for _, app := range c.Apps {
		for _, file := range app.Files {
			if err := replaceFile(file.External, file.Internal); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", file.External, file.Internal, err)
			}
		}

		for _, dir := range app.Dirs {
			if err := replaceDir(dir.External, dir.Internal); err != nil {
				return fmt.Errorf("failed to remove and copy from %s to %s: %w", dir.External, dir.Internal, err)
			}
		}
	}

	return nil
}

func (c *Config) Clean() error {
	fileInfos, err := ioutil.ReadDir(configDirPath)
	if err != nil {
		return fmt.Errorf("failed to read dir %s: %w", configDirPath, err)
	}

	unusedDirs := make(map[string]struct{})
	for _, fileInfo := range fileInfos {
		if fileInfo.Name() == configFile {
			continue
		}

		unusedDirs[fileInfo.Name()] = struct{}{}
	}

	// removed used apps
	for name := range c.Apps {
		delete(unusedDirs, name)
	}

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

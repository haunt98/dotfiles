package config

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/make-go-great/copy-go"
	"github.com/make-go-great/diff-go"
)

type configReal struct {
	configApps
}

var _ Config = (*configReal)(nil)

// Install internal -> external
func (c *configReal) Install() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if err := copy.Replace(p.Internal, p.External); err != nil {
				return fmt.Errorf("failed to replace %s -> %s: %w", p.Internal, p.External, err)
			}
		}
	}

	return nil
}

// Update external -> internal
func (c *configReal) Update() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if err := copy.Replace(p.External, p.Internal); err != nil {
				return fmt.Errorf("failed to replace %s -> %s: %w", p.External, p.Internal, err)
			}
		}
	}

	return nil
}

// Clean remove unused config inside config dir
func (c *configReal) Clean() error {
	unusedDirs, err := getUnusedDirs(c.Apps)
	if err != nil {
		return err
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

func (c *configReal) Diff() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if err := diff.Diff(p.Internal, p.External); err != nil {
				return fmt.Errorf("failed to compare %s with %s: %w", p.Internal, p.External, err)
			}
		}
	}

	return nil
}

func getUnusedDirs(apps map[string]App) (map[string]struct{}, error) {
	files, err := os.ReadDir(configDirPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read dir %s: %w", configDirPath, err)
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
	for name := range apps {
		delete(unusedDirs, name)
	}

	return unusedDirs, nil
}

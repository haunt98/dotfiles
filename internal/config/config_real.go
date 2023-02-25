package config

import (
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"

	"github.com/make-go-great/copy-go"
	"github.com/make-go-great/diff-go"
)

var ErrConfigInvalid = errors.New("config invalid")

type configReal struct {
	httpClient *http.Client
	ConfigApps
}

var _ Config = (*configReal)(nil)

// Install internal -> external
func (c *configReal) Install() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if p.External == "" {
				continue
			}

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
			if p.External == "" {
				continue
			}

			if err := copy.Replace(p.External, p.Internal); err != nil {
				return fmt.Errorf("failed to replace %s -> %s: %w", p.External, p.Internal, err)
			}
		}
	}

	return nil
}

func (c *configReal) Download() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if p.URL == "" {
				continue
			}

			httpRsp, err := c.httpClient.Get(p.URL)
			if err != nil {
				return fmt.Errorf("http client: failed to get: %w", err)
			}

			data, err := io.ReadAll(httpRsp.Body)
			if err != nil {
				return fmt.Errorf("io: failed to read all: %w", err)
			}

			// Copy from github.com/make-go-great/copy-go
			// Make sure nested dir is exist before copying file
			dstDir := filepath.Dir(p.Internal)
			if err := os.MkdirAll(dstDir, os.ModePerm); err != nil {
				return fmt.Errorf("failed to mkdir %s: %w", dstDir, err)
			}

			if err := os.WriteFile(p.Internal, data, 0o600); err != nil {
				return fmt.Errorf("os: failed to write file: %w", err)
			}

			httpRsp.Body.Close()
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

func getUnusedDirs(apps map[string]App) (map[string]struct{}, error) {
	files, err := os.ReadDir(configDirPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read dir %s: %w", configDirPath, err)
	}

	// Get all dirs inside config dir
	unusedDirs := make(map[string]struct{})
	for _, file := range files {
		// Ignore config file
		if file.Name() == configFileJSON {
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

func (c *configReal) Diff() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if p.External == "" {
				continue
			}

			if err := diff.Diff(p.Internal, p.External); err != nil {
				return fmt.Errorf("failed to compare %s with %s: %w", p.Internal, p.External, err)
			}
		}
	}

	return nil
}

func (c *configReal) Validate() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if p.Internal == "" {
				return fmt.Errorf("empty internal app [%s]: %w", app, ErrConfigInvalid)
			}

			if p.External == "" && p.URL == "" {
				return fmt.Errorf("empty external and url app [%s]: %w", app, ErrConfigInvalid)
			}
		}
	}

	return nil
}

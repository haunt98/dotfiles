package config

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"sort"

	"github.com/BurntSushi/toml"
	"github.com/bytedance/sonic"
	"github.com/sourcegraph/conc/pool"

	"github.com/make-go-great/copy-go"
	"github.com/make-go-great/diff-go"
)

const (
	configDirPath  = "data"
	configFileJSON = "data.json"
	configFileTOML = "data.toml"

	maxPoolGoroutines = 8
)

var (
	ErrConfigNotFound = errors.New("config not found")
	ErrConfigInvalid  = errors.New("config invalid")
)

type Config interface {
	Install() error
	Update() error
	Clean() error
	Diff() error
	Validate() error
	List() []string
}

type cfg struct {
	cfgApps  ConfigApps
	isDryRun bool
}

// LoadConfig return config, configDemo
func LoadConfig(path string, isDryRun bool) (Config, error) {
	configPathJSON := filepath.Clean(filepath.Join(path, configDirPath, configFileJSON))
	bytes, err := os.ReadFile(configPathJSON)
	if err == nil {
		return loadConfig(bytes, isDryRun, sonic.Unmarshal)
	}

	configPathTOML := filepath.Clean(filepath.Join(path, configDirPath, configFileTOML))
	bytes, err = os.ReadFile(configPathTOML)
	if err == nil {
		return loadConfig(bytes, isDryRun, toml.Unmarshal)
	}

	return nil, ErrConfigNotFound
}

func loadConfig(bytes []byte, isDryRun bool, unmarshalFn func(data []byte, v any) error) (Config, error) {
	var cfgApps ConfigApps
	if err := unmarshalFn(bytes, &cfgApps); err != nil {
		return nil, fmt.Errorf("failed to unmarshal: %w", err)
	}

	// Sort version
	apps2 := make([]string, 0, len(cfgApps.Apps))

	for appName := range cfgApps.Apps {
		apps2 = append(apps2, appName)
	}

	sort.Strings(apps2)
	cfgApps.SortedApps = apps2

	return &cfg{
		cfgApps:  cfgApps,
		isDryRun: isDryRun,
	}, nil
}

// Install internal -> external
func (c *cfg) Install() error {
	p := pool.New().
		WithErrors().
		WithMaxGoroutines(maxPoolGoroutines).
		WithFirstError()

	for _, app := range c.cfgApps.Apps {
		for _, path := range app.Paths {
			if path.External == "" {
				continue
			}

			p.Go(func() error {
				if c.isDryRun {
					fmt.Printf("Replace [%s] -> [%s]\n", path.Internal, path.External)
					return nil
				}

				if err := copy.Replace(path.Internal, path.External); err != nil {
					return fmt.Errorf("copy: failed to replace [%s] -> [%s]: %w", path.Internal, path.External, err)
				}

				return nil
			})
		}
	}

	return p.Wait()
}

// Update external -> internal
func (c *cfg) Update() error {
	p := pool.New().
		WithErrors().
		WithMaxGoroutines(maxPoolGoroutines).
		WithFirstError()

	for _, app := range c.cfgApps.Apps {
		for _, path := range app.Paths {
			if path.External == "" {
				continue
			}

			p.Go(func() error {
				if c.isDryRun {
					fmt.Printf("Replace [%s] -> [%s]\n", path.External, path.Internal)
					return nil
				}

				if err := copy.Replace(path.External, path.Internal); err != nil {
					return fmt.Errorf("copy: failed to replace [%s] -> [%s]: %w", path.External, path.Internal, err)
				}

				return nil
			})
		}
	}

	return p.Wait()
}

// Clean remove unused config inside config dir
func (c *cfg) Clean() error {
	unusedDirs, err := getUnusedDirs(c.cfgApps.Apps)
	if err != nil {
		return err
	}

	// Delete unused dirs to save some space
	for dir := range unusedDirs {
		if c.isDryRun {
			fmt.Printf("Remove [%s]\n", dir)
			continue
		}

		dirPath := filepath.Join(configDirPath, dir)
		if err := os.RemoveAll(dirPath); err != nil {
			return fmt.Errorf("os: failed to remove all [%s]: %w", dir, err)
		}
	}

	return nil
}

func getUnusedDirs(apps map[string]App) (map[string]struct{}, error) {
	files, err := os.ReadDir(configDirPath)
	if err != nil {
		return nil, fmt.Errorf("os: failed to read dir [%s]: %w", configDirPath, err)
	}

	// Get all dirs inside config dir
	unusedDirs := make(map[string]struct{})
	for _, file := range files {
		// Ignore config file
		if file.Name() == configFileJSON ||
			file.Name() == configFileTOML {
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

func (c *cfg) Diff() error {
	for _, app := range c.cfgApps.Apps {
		for _, p := range app.Paths {
			if p.External == "" {
				continue
			}

			if err := diff.Diff(p.Internal, p.External); err != nil {
				return fmt.Errorf("diff: failed to compare [%s] with [%s]: %w", p.Internal, p.External, err)
			}
		}
	}

	return nil
}

func (c *cfg) Validate() error {
	for appName, app := range c.cfgApps.Apps {
		for _, path := range app.Paths {
			if path.Internal == "" {
				return fmt.Errorf("empty internal app [%s]: %w", appName, ErrConfigInvalid)
			}

			if path.External == "" {
				return fmt.Errorf("empty external app [%s]: %w", appName, ErrConfigInvalid)
			}
		}
	}

	return nil
}

func (c *cfg) List() []string {
	return c.cfgApps.SortedApps
}

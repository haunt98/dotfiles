package config

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"sort"

	"github.com/BurntSushi/toml"
	"golang.org/x/sync/errgroup"

	"github.com/make-go-great/copy-go"
	"github.com/make-go-great/diff-go"
)

const (
	configDirPath  = "data"
	configFileJSON = "data.json"
	configFileTOML = "data.toml"
)

var (
	ErrConfigNotFound = errors.New("config not found")
	ErrConfigInvalid  = errors.New("config invalid")
)

type Config interface {
	Install(appNames ...string) error
	Update(appNames ...string) error
	Clean() error
	Diff(appNames ...string) error
	Download(appNames ...string) error
	Validate(appNames ...string) error
	List() []string
}

type cfg struct {
	cfgApps  ConfigApps
	isDryRun bool
}

// LoadConfig return config, configDemo
func LoadConfig(path string, isDryRun bool) (Config, error) {
	configPathJSON := filepath.Join(path, configDirPath, configFileJSON)
	bytes, err := os.ReadFile(configPathJSON)
	if err == nil {
		return loadConfig(bytes, isDryRun, json.Unmarshal)
	}

	configPathTOML := filepath.Join(path, configDirPath, configFileTOML)
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
	cfgApps.Apps2 = apps2

	return &cfg{
		cfgApps:  cfgApps,
		isDryRun: isDryRun,
	}, nil
}

// Install internal -> external
func (c *cfg) Install(appNames ...string) error {
	var eg errgroup.Group

	mAppNames := slice2map(appNames)

	for appName, app := range c.cfgApps.Apps {
		if len(appNames) > 0 {
			if _, ok := mAppNames[appName]; !ok {
				continue
			}
		}

		for _, p := range app.Paths {
			if p.External == "" {
				continue
			}

			p := Path{
				Internal: p.Internal,
				External: p.External,
				URL:      p.URL,
			}

			eg.Go(func() error {
				if c.isDryRun {
					fmt.Printf("Replace [%s] -> [%s]\n", p.Internal, p.External)
					return nil
				}

				if err := copy.Replace(p.Internal, p.External); err != nil {
					return fmt.Errorf("copy: failed to replace [%s] -> [%s]: %w", p.Internal, p.External, err)
				}

				return nil
			})
		}
	}

	if err := eg.Wait(); err != nil {
		return err
	}

	return nil
}

// Update external -> internal
func (c *cfg) Update(appNames ...string) error {
	var eg errgroup.Group

	mAppNames := slice2map(appNames)

	for appName, app := range c.cfgApps.Apps {
		if len(appNames) > 0 {
			if _, ok := mAppNames[appName]; !ok {
				continue
			}
		}

		for _, p := range app.Paths {
			if p.External == "" {
				continue
			}

			p := Path{
				Internal: p.Internal,
				External: p.External,
				URL:      p.URL,
			}

			eg.Go(func() error {
				if c.isDryRun {
					fmt.Printf("Replace [%s] -> [%s]\n", p.External, p.Internal)
					return nil
				}

				if err := copy.Replace(p.External, p.Internal); err != nil {
					return fmt.Errorf("copy: failed to replace [%s] -> [%s]: %w", p.External, p.Internal, err)
				}

				return nil
			})
		}
	}

	if err := eg.Wait(); err != nil {
		return err
	}

	return nil
}

func (c *cfg) Download(appNames ...string) error {
	var eg errgroup.Group

	mAppNames := slice2map(appNames)

	for appName, app := range c.cfgApps.Apps {
		if len(appNames) > 0 {
			if _, ok := mAppNames[appName]; !ok {
				continue
			}
		}

		for _, p := range app.Paths {
			if p.URL == "" {
				continue
			}

			p := Path{
				Internal: p.Internal,
				External: p.External,
				URL:      p.URL,
			}

			httpClient := &http.Client{}

			eg.Go(func() error {
				if c.isDryRun {
					fmt.Printf("Download [%s] -> [%s]\n", p.URL, p.Internal)
					return nil
				}

				// nolint:noctx,gosec
				httpRsp, err := httpClient.Get(p.URL)
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
					return fmt.Errorf("os: failed to mkdir all [%s]: %w", dstDir, err)
				}

				if err := os.WriteFile(p.Internal, data, 0o600); err != nil {
					return fmt.Errorf("os: failed to write file: %w", err)
				}

				httpRsp.Body.Close()

				return nil
			})

		}
	}

	if err := eg.Wait(); err != nil {
		return err
	}

	return nil
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

func (c *cfg) Diff(appNames ...string) error {
	mAppNames := slice2map(appNames)

	for appName, app := range c.cfgApps.Apps {
		if len(appNames) > 0 {
			if _, ok := mAppNames[appName]; !ok {
				continue
			}
		}

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

func (c *cfg) Validate(appNames ...string) error {
	var eg errgroup.Group

	mAppNames := slice2map(appNames)

	for appName, app := range c.cfgApps.Apps {
		if len(appNames) > 0 {
			if _, ok := mAppNames[appName]; !ok {
				continue
			}
		}

		for _, p := range app.Paths {
			app := app
			p := Path{
				Internal: p.Internal,
				External: p.External,
				URL:      p.URL,
			}

			eg.Go(func() error {
				if p.Internal == "" {
					return fmt.Errorf("empty internal app [%s]: %w", app, ErrConfigInvalid)
				}

				if p.External == "" && p.URL == "" {
					return fmt.Errorf("empty external and url app [%s]: %w", app, ErrConfigInvalid)
				}

				return nil
			})
		}
	}

	if err := eg.Wait(); err != nil {
		return err
	}

	return nil
}

func (c *cfg) List() []string {
	return c.cfgApps.Apps2
}

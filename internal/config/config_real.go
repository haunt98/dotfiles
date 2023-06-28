package config

import (
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"

	"golang.org/x/sync/errgroup"

	"github.com/make-go-great/copy-go"
	"github.com/make-go-great/diff-go"
)

var ErrConfigInvalid = errors.New("config invalid")

type ConfigReal struct {
	httpClient *http.Client
	ConfigApps
}

var _ Config = (*ConfigReal)(nil)

// Install internal -> external
func (c *ConfigReal) Install() error {
	eg := new(errgroup.Group)

	for _, app := range c.Apps {
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
func (c *ConfigReal) Update() error {
	eg := new(errgroup.Group)

	for _, app := range c.Apps {
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

func (c *ConfigReal) Download() error {
	eg := new(errgroup.Group)

	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if p.URL == "" {
				continue
			}

			p := Path{
				Internal: p.Internal,
				External: p.External,
				URL:      p.URL,
			}

			eg.Go(func() error {
				// nolint:noctx
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
func (c *ConfigReal) Clean() error {
	unusedDirs, err := getUnusedDirs(c.Apps)
	if err != nil {
		return err
	}

	// Delete ununsed dirs to save some space
	for dir := range unusedDirs {
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

func (c *ConfigReal) Diff() error {
	for _, app := range c.Apps {
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

func (c *ConfigReal) Validate() error {
	eg := new(errgroup.Group)

	for _, app := range c.Apps {
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

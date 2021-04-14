package main

import (
	"fmt"
	"os"
	"runtime"

	"github.com/haunt98/color"
	"github.com/urfave/cli/v2"
)

const (
	appName = "dotfiles"

	installCommand = "install"
	updateCommand  = "update"
	cleanCommand   = "clean"

	currentDir = "."
)

var (
	installAliases = []string{"i"}
	updateAliases  = []string{"u"}
	cleanAliases   = []string{"c"}

	// denyOSes contains OS which is not supported
	// go tool dist list
	denyOSes = map[string]struct{}{
		"windows": struct{}{},
	}
)

func main() {
	// Prevent running at runtime
	if _, ok := denyOSes[runtime.GOOS]; ok {
		color.PrintAppError(appName, fmt.Sprintf("OS %s is not supported right now", runtime.GOOS))
		return
	}

	a := &action{}

	app := &cli.App{
		Name:  appName,
		Usage: "managing dotfiles",
		Commands: []*cli.Command{
			{
				Name:    installCommand,
				Aliases: installAliases,
				Usage:   "install user configs from dotfiles",
				Action:  a.RunInstall,
			},
			{
				Name:    updateCommand,
				Aliases: updateAliases,
				Usage:   "update dotfiles from user configs",
				Action:  a.RunUpdate,
			},
			{
				Name:    cleanCommand,
				Aliases: cleanAliases,
				Usage:   "clean unused dotfiles",
				Action:  a.RunClean,
			},
		},
		Action: a.Run,
	}

	if err := app.Run(os.Args); err != nil {
		color.PrintAppError(appName, err.Error())
	}
}

type action struct{}

// Show help by default
func (a *action) Run(c *cli.Context) error {
	return cli.ShowAppHelp(c)
}

func (a *action) RunInstall(c *cli.Context) error {
	cfg, err := LoadConfig(currentDir)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}

	if err := cfg.Install(); err != nil {
		return fmt.Errorf("failed to install config: %w", err)
	}

	return nil
}

func (a *action) RunUpdate(c *cli.Context) error {
	cfg, err := LoadConfig(currentDir)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}

	if err := cfg.Update(); err != nil {
		return fmt.Errorf("failed to update config: %w", err)
	}

	return nil
}

func (a *action) RunClean(c *cli.Context) error {
	cfg, err := LoadConfig(currentDir)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}

	if err := cfg.Clean(); err != nil {
		return fmt.Errorf("failed to clean config: %w", err)
	}

	return nil
}

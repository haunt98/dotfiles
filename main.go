package main

import (
	"fmt"
	"os"

	"github.com/fatih/color"
	"github.com/urfave/cli/v2"
)

const (
	appName = "dotfiles"

	installCommand = "install"
	updateCommand  = "update"
	cleanCommand   = "clean"

	curentDir = "."
)

func main() {
	a := &action{}

	app := &cli.App{
		Name:  appName,
		Usage: "managing dotfiles",
		Commands: []*cli.Command{
			{
				Name:    installCommand,
				Aliases: []string{"i"},
				Usage:   "install user configs from dotfiles",
				Action:  a.RunInstall,
			},
			{
				Name:    updateCommand,
				Aliases: []string{"u"},
				Usage:   "update dotfiles from user configs",
				Action:  a.RunUpdate,
			},
			{
				Name:    cleanCommand,
				Aliases: []string{"c"},
				Usage:   "clean unused dotfiles",
				Action:  a.RunClean,
			},
		},
		Action: a.Run,
	}

	if err := app.Run(os.Args); err != nil {
		// Highlight error
		fmtErr := color.New(color.FgRed)
		fmtErr.Printf("[%s error]: ", appName)
		fmt.Printf("%s\n", err.Error())
	}
}

type action struct{}

// Show help by default
func (a *action) Run(c *cli.Context) error {
	return cli.ShowAppHelp(c)
}

func (a *action) RunInstall(c *cli.Context) error {
	cfg, err := LoadConfig(curentDir)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}

	if err := cfg.Install(); err != nil {
		return fmt.Errorf("failed to install config: %w", err)
	}

	return nil
}

func (a *action) RunUpdate(c *cli.Context) error {
	cfg, err := LoadConfig(curentDir)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}

	if err := cfg.Update(); err != nil {
		return fmt.Errorf("failed to update config: %w", err)
	}

	return nil
}

func (a *action) RunClean(c *cli.Context) error {
	cfg, err := LoadConfig(curentDir)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}

	if err := cfg.Clean(); err != nil {
		return fmt.Errorf("failed to clean config: %w", err)
	}

	return nil
}

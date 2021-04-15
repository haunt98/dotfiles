package main

import (
	"fmt"
	"log"
	"os"
	"runtime"

	"github.com/haunt98/color"
	"github.com/urfave/cli/v2"
)

const (
	appName  = "dotfiles"
	appUsage = "managing dotfiles"

	// flags
	verboseFlag = "verbose"
	dryRunFlag  = "dry-run"

	// commands
	installCommand = "install"
	updateCommand  = "update"
	cleanCommand   = "clean"

	// usages
	verboseUsage = "show what is going on"
	dryRunUsage  = "demo mode without actually changing anything"
	installUsage = "install user configs from dotfiles"
	updateUsage  = "update dotfiles from user configs"
	cleanUsage   = "clean unused dotfiles"

	currentDir = "."
)

var (
	// aliases
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
		Usage: appUsage,
		Commands: []*cli.Command{
			{
				Name:    installCommand,
				Aliases: installAliases,
				Usage:   installUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  verboseFlag,
						Usage: verboseUsage,
					},
					&cli.BoolFlag{
						Name:  dryRunFlag,
						Usage: dryRunUsage,
					},
				},
				Action: a.RunInstall,
			},
			{
				Name:    updateCommand,
				Aliases: updateAliases,
				Usage:   updateUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  verboseFlag,
						Usage: verboseUsage,
					},
					&cli.BoolFlag{
						Name:  dryRunFlag,
						Usage: dryRunUsage,
					},
				},
				Action: a.RunUpdate,
			},
			{
				Name:    cleanCommand,
				Aliases: cleanAliases,
				Usage:   cleanUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  verboseFlag,
						Usage: verboseUsage,
					},
					&cli.BoolFlag{
						Name:  dryRunFlag,
						Usage: dryRunUsage,
					},
				},
				Action: a.RunClean,
			},
		},
		Action: a.RunHelp,
	}

	if err := app.Run(os.Args); err != nil {
		color.PrintAppError(appName, err.Error())
	}
}

type action struct {
	flags struct {
		verbose bool
	}
}

// Show help by default
func (a *action) RunHelp(c *cli.Context) error {
	return cli.ShowAppHelp(c)
}

func (a *action) RunInstall(c *cli.Context) error {
	a.getFlags(c)
	a.log("start %s\n", installCommand)

	cfg, err := LoadConfig(currentDir)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}
	a.log("config %+v\n", cfg)

	if err := cfg.Install(); err != nil {
		return fmt.Errorf("failed to install config: %w", err)
	}

	return nil
}

func (a *action) RunUpdate(c *cli.Context) error {
	a.getFlags(c)
	a.log("start %s\n", updateCommand)

	cfg, err := LoadConfig(currentDir)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}
	a.log("config %+v\n", cfg)

	if err := cfg.Update(); err != nil {
		return fmt.Errorf("failed to update config: %w", err)
	}

	return nil
}

func (a *action) RunClean(c *cli.Context) error {
	a.getFlags(c)
	a.log("start %s\n", cleanCommand)

	cfg, err := LoadConfig(currentDir)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}
	a.log("config %+v\n", cfg)

	if err := cfg.Clean(); err != nil {
		return fmt.Errorf("failed to clean config: %w", err)
	}

	return nil
}

func (a *action) getFlags(c *cli.Context) {
	a.flags.verbose = c.Bool(verboseFlag)
}

func (a *action) log(format string, v ...interface{}) {
	if a.flags.verbose {
		log.Printf(format, v...)
	}
}

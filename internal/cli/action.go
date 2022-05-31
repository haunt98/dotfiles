package cli

import (
	"fmt"
	"log"

	"github.com/haunt98/dotfiles/internal/config"
	"github.com/urfave/cli/v2"
)

type action struct {
	flags struct {
		verbose bool
		dryRun  bool
	}
}

// Show help by default
func (a *action) runHelp(c *cli.Context) error {
	return cli.ShowAppHelp(c)
}

func (a *action) runInstall(c *cli.Context) error {
	a.getFlags(c)
	a.log("start %s\n", installCommand)

	cfg, err := a.loadConfig()
	if err != nil {
		return err
	}

	if err := cfg.Install(); err != nil {
		return fmt.Errorf("failed to install config: %w", err)
	}

	return nil
}

func (a *action) runUpdate(c *cli.Context) error {
	a.getFlags(c)
	a.log("start %s\n", updateCommand)

	cfg, err := a.loadConfig()
	if err != nil {
		return err
	}

	if err := cfg.Update(); err != nil {
		return fmt.Errorf("failed to update config: %w", err)
	}

	return nil
}

func (a *action) runClean(c *cli.Context) error {
	a.getFlags(c)
	a.log("start %s\n", cleanCommand)

	cfg, err := a.loadConfig()
	if err != nil {
		return err
	}

	if err := cfg.Clean(); err != nil {
		return fmt.Errorf("failed to clean config: %w", err)
	}

	return nil
}

func (a *action) runDiff(c *cli.Context) error {
	a.getFlags(c)
	a.log("start %s\n", diffCommand)

	cfg, err := a.loadConfig()
	if err != nil {
		return err
	}

	if err := cfg.Diff(); err != nil {
		return fmt.Errorf("failed to compare config: %w", err)
	}

	return nil
}

func (a *action) loadConfig() (config.Config, error) {
	cfgReal, cfgDemo, err := config.LoadConfig(currentDir)
	if err != nil {
		return nil, fmt.Errorf("failed to load config: %w", err)
	}

	if a.flags.dryRun {
		return cfgDemo, nil
	}

	return cfgReal, nil
}

func (a *action) getFlags(c *cli.Context) {
	a.flags.verbose = c.Bool(verboseFlag)
	a.flags.dryRun = c.Bool(dryRunFlag)
}

func (a *action) log(format string, v ...interface{}) {
	if a.flags.verbose {
		log.Printf(format, v...)
	}
}

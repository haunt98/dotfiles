package cli

import (
	"fmt"
	"log"

	"github.com/urfave/cli/v2"

	"github.com/haunt98/dotfiles/internal/config"
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
	cfg, err := a.loadConfig(c, installCommand)
	if err != nil {
		return err
	}

	if err := cfg.Install(); err != nil {
		return fmt.Errorf("config: failed to install: %w", err)
	}

	return nil
}

func (a *action) runUpdate(c *cli.Context) error {
	cfg, err := a.loadConfig(c, updateCommand)
	if err != nil {
		return err
	}

	if err := cfg.Update(); err != nil {
		return fmt.Errorf("config: failed to update: %w", err)
	}

	return nil
}

func (a *action) runDownload(c *cli.Context) error {
	cfg, err := a.loadConfig(c, downloadCommand)
	if err != nil {
		return err
	}

	if err := cfg.Download(); err != nil {
		return fmt.Errorf("config: failed to download: %w", err)
	}

	return nil
}

func (a *action) runClean(c *cli.Context) error {
	cfg, err := a.loadConfig(c, cleanCommand)
	if err != nil {
		return err
	}

	if err := cfg.Clean(); err != nil {
		return fmt.Errorf("config: failed to clean: %w", err)
	}

	return nil
}

func (a *action) runDiff(c *cli.Context) error {
	cfg, err := a.loadConfig(c, diffCommand)
	if err != nil {
		return err
	}

	if err := cfg.Diff(); err != nil {
		return fmt.Errorf("config: failed to compare: %w", err)
	}

	return nil
}

func (a *action) runValidate(c *cli.Context) error {
	cfg, err := a.loadConfig(c, validateCommand)
	if err != nil {
		return err
	}

	if err := cfg.Validate(); err != nil {
		return fmt.Errorf("config: failed to validate: %w", err)
	}

	return nil
}

func (a *action) loadConfig(c *cli.Context, command string) (config.Config, error) {
	a.getFlags(c)
	a.log("start %s with flags %+v\n", command, a.flags)

	cfgReal, cfgDemo, err := config.LoadConfig(currentDir)
	if err != nil {
		return nil, fmt.Errorf("config: failed to load: %w", err)
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

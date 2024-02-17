package cli

import (
	"fmt"
	"log"

	"github.com/urfave/cli/v2"

	"github.com/haunt98/dotfiles/internal/config"
)

type action struct {
	flags struct {
		appNames []string
		verbose  bool
		dryRun   bool
	}
}

// Show help by default
func (a *action) runHelp(c *cli.Context) error {
	return cli.ShowAppHelp(c)
}

func (a *action) runInstall(c *cli.Context) error {
	cfg, err := a.loadConfig(c, commandInstallName)
	if err != nil {
		return err
	}

	if err := cfg.Install(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to install: %w", err)
	}

	return nil
}

func (a *action) runUpdate(c *cli.Context) error {
	cfg, err := a.loadConfig(c, commandUpdateName)
	if err != nil {
		return err
	}

	if err := cfg.Update(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to update: %w", err)
	}

	return nil
}

func (a *action) runDownload(c *cli.Context) error {
	cfg, err := a.loadConfig(c, commandDownloadName)
	if err != nil {
		return err
	}

	if err := cfg.Download(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to download: %w", err)
	}

	return nil
}

func (a *action) runClean(c *cli.Context) error {
	cfg, err := a.loadConfig(c, commandCleanName)
	if err != nil {
		return err
	}

	if err := cfg.Clean(); err != nil {
		return fmt.Errorf("config: failed to clean: %w", err)
	}

	return nil
}

func (a *action) runDiff(c *cli.Context) error {
	cfg, err := a.loadConfig(c, commandDiffName)
	if err != nil {
		return err
	}

	if err := cfg.Diff(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to compare: %w", err)
	}

	return nil
}

func (a *action) runValidate(c *cli.Context) error {
	cfg, err := a.loadConfig(c, commandValidateName)
	if err != nil {
		return err
	}

	if err := cfg.Validate(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to validate: %w", err)
	}

	return nil
}

func (a *action) loadConfig(c *cli.Context, command string) (config.Config, error) {
	a.getFlags(c)
	a.log("Start command [%s] with flags [%+v]\n", command, a.flags)

	cfgReal, cfgDemo, err := config.LoadConfig(currentDir)
	if err != nil {
		return nil, fmt.Errorf("config: failed to load: %w", err)
	}
	a.log("Config apps [%+v]\n", cfgReal.Apps)

	if a.flags.dryRun {
		return cfgDemo, nil
	}

	return cfgReal, nil
}

func (a *action) getFlags(c *cli.Context) {
	a.flags.verbose = c.Bool(flagVerboseName)
	a.flags.dryRun = c.Bool(flagDryRunName)
	a.flags.appNames = c.StringSlice(flagAppName)
}

func (a *action) log(format string, v ...interface{}) {
	if a.flags.verbose {
		log.Printf(format, v...)
	}
}

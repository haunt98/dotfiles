package cli

import (
	"context"
	"fmt"
	"log"

	"github.com/urfave/cli/v3"

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
func (a *action) runHelp(ctx context.Context, c *cli.Command) error {
	return cli.ShowAppHelp(c)
}

func (a *action) runInstall(ctx context.Context, c *cli.Command) error {
	cfg, err := a.loadConfig(c, commandInstallName)
	if err != nil {
		return err
	}

	if err := cfg.Install(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to install: %w", err)
	}

	return nil
}

func (a *action) runUpdate(ctx context.Context, c *cli.Command) error {
	cfg, err := a.loadConfig(c, commandUpdateName)
	if err != nil {
		return err
	}

	if err := cfg.Update(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to update: %w", err)
	}

	return nil
}

func (a *action) runDownload(ctx context.Context, c *cli.Command) error {
	cfg, err := a.loadConfig(c, commandDownloadName)
	if err != nil {
		return err
	}

	if err := cfg.Download(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to download: %w", err)
	}

	return nil
}

func (a *action) runClean(ctx context.Context, c *cli.Command) error {
	cfg, err := a.loadConfig(c, commandCleanName)
	if err != nil {
		return err
	}

	if err := cfg.Clean(); err != nil {
		return fmt.Errorf("config: failed to clean: %w", err)
	}

	return nil
}

func (a *action) runDiff(ctx context.Context, c *cli.Command) error {
	cfg, err := a.loadConfig(c, commandDiffName)
	if err != nil {
		return err
	}

	if err := cfg.Diff(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to compare: %w", err)
	}

	return nil
}

func (a *action) runValidate(ctx context.Context, c *cli.Command) error {
	cfg, err := a.loadConfig(c, commandValidateName)
	if err != nil {
		return err
	}

	if err := cfg.Validate(a.flags.appNames...); err != nil {
		return fmt.Errorf("config: failed to validate: %w", err)
	}

	return nil
}

func (a *action) loadConfig(c *cli.Command, command string) (config.Config, error) {
	a.getFlags(c)
	a.log("Start command [%s] with flags [%+v]\n", command, a.flags)

	cfg, err := config.LoadConfig(currentDir, a.flags.dryRun)
	if err != nil {
		return nil, fmt.Errorf("config: failed to load: %w", err)
	}
	a.log("Config apps %+v\n", cfg.List())

	return cfg, nil
}

func (a *action) getFlags(c *cli.Command) {
	a.flags.verbose = c.Bool(flagVerboseName)
	a.flags.dryRun = c.Bool(flagDryRunName)
	a.flags.appNames = c.StringSlice(flagAppName)
}

func (a *action) log(format string, v ...any) {
	if a.flags.verbose {
		log.Printf(format, v...)
	}
}

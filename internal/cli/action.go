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
		verbose bool
		dryRun  bool
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

	if err := cfg.Install(); err != nil {
		return fmt.Errorf("config: failed to install: %w", err)
	}

	return nil
}

func (a *action) runUpdate(ctx context.Context, c *cli.Command) error {
	cfg, err := a.loadConfig(c, commandUpdateName)
	if err != nil {
		return err
	}

	if err := cfg.Update(); err != nil {
		return fmt.Errorf("config: failed to update: %w", err)
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

	if err := cfg.Diff(); err != nil {
		return fmt.Errorf("config: failed to compare: %w", err)
	}

	return nil
}

func (a *action) runValidate(ctx context.Context, c *cli.Command) error {
	cfg, err := a.loadConfig(c, commandValidateName)
	if err != nil {
		return err
	}

	if err := cfg.Validate(); err != nil {
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
}

func (a *action) log(format string, v ...any) {
	if a.flags.verbose {
		log.Printf(format, v...)
	}
}

package main

import (
	"fmt"
	"os"

	"github.com/fatih/color"
	"github.com/urfave/cli/v2"
)

const (
	appName = "dotfiles"

	pathFlag = "path"

	installCommand = "install"
	updateCommand  = "update"
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
				Usage:   "install configs from dotfiles",
			},
			{
				Name:    updateCommand,
				Aliases: []string{"u"},
				Usage:   "update dotfiles from configs",
			},
		},
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:  "pathFlag",
				Usage: "path to `DOTFILES`",
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

type action struct {
	flags struct {
		path string
	}
}

// Show help by default
func (a *action) Run(c *cli.Context) error {
	return cli.ShowAppHelp(c)
}

func (a *action) RunInstall(c *cli.Context) error {
	a.getFlags(c)

	cfg, err := LoadConfig(a.flags.path)
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}

	return nil
}

func (a *action) getFlags(c *cli.Context) {
	a.flags.path = c.String(pathFlag)
}

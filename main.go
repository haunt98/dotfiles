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
	}

	if err := app.Run(os.Args); err != nil {
		// Highlight error
		fmtErr := color.New(color.FgRed)
		fmtErr.Printf("[%s error]: ", appName)
		fmt.Printf("%s\n", err.Error())
	}
}

package cli

import (
	"fmt"
	"os"
	"runtime"

	"github.com/urfave/cli/v2"

	"github.com/make-go-great/color-go"
)

const (
	appName  = "dotfiles"
	appUsage = "managing dotfiles"

	installCommand = "install"
	installUsage   = "install user configs from dotfiles"

	updateCommand = "update"
	updateUsage   = "update dotfiles from user configs"

	downloadCommand = "download"
	downloadUsage   = "download configs from internet (theme for example)"

	cleanCommand = "clean"
	cleanUsage   = "clean unused dotfiles"

	diffCommand = "diff"
	diffUsage   = "diff dotfiles with user configs"

	verboseFlag  = "verbose"
	verboseUsage = "show what is going on"

	dryRunFlag  = "dry-run"
	dryRunUsage = "demo mode without actually changing anything"

	currentDir = "."
)

var (
	installAliases  = []string{"i"}
	updateAliases   = []string{"u"}
	downloadAliases = []string{"d"}
	cleanAliases    = []string{"c"}
	diffAliases     = []string{"df"}
)

// denyOSes contains OS which is not supported
// go tool dist list
var denyOSes = map[string]struct{}{
	"windows": {},
}

type App struct {
	cliApp *cli.App
}

func NewApp() *App {
	a := &action{}

	cliApp := &cli.App{
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
				Action: a.runInstall,
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
				Action: a.runUpdate,
			},
			{
				Name:    downloadCommand,
				Aliases: downloadAliases,
				Usage:   downloadUsage,
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
				Action: a.runDownload,
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
				Action: a.runClean,
			},
			{
				Name:    diffCommand,
				Aliases: diffAliases,
				Usage:   diffUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  verboseFlag,
						Usage: verboseUsage,
					},
				},
				Action: a.runDiff,
			},
		},
		Action: a.runHelp,
	}

	return &App{
		cliApp: cliApp,
	}
}

func (a *App) Run() {
	// Prevent running at runtime
	if _, ok := denyOSes[runtime.GOOS]; ok {
		color.PrintAppError(appName, fmt.Sprintf("OS %s is not supported right now", runtime.GOOS))
		return
	}

	if err := a.cliApp.Run(os.Args); err != nil {
		color.PrintAppError(appName, err.Error())
	}
}

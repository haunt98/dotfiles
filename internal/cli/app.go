package cli

import (
	"fmt"
	"os"
	"runtime"

	"github.com/make-go-great/color-go"
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
	compareCommand = "compare"

	// flag usages
	verboseUsage = "show what is going on"
	dryRunUsage  = "demo mode without actually changing anything"

	// command usages
	installUsage = "install user configs from dotfiles"
	updateUsage  = "update dotfiles from user configs"
	cleanUsage   = "clean unused dotfiles"
	compareUsage = "compare dotfiles with user configs"

	currentDir = "."
)

var (
	// command aliases
	installAliases = []string{"i"}
	updateAliases  = []string{"u"}
	cleanAliases   = []string{"c"}
	compareAliases = []string{"cmp"}
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
				Name:    compareCommand,
				Aliases: compareAliases,
				Usage:   compareUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  verboseFlag,
						Usage: verboseUsage,
					},
				},
				Action: a.runCompare,
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

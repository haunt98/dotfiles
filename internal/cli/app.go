package cli

import (
	"fmt"
	"os"
	"runtime"

	"github.com/urfave/cli/v2"

	"github.com/make-go-great/color-go"
)

const (
	name  = "dotfiles"
	usage = "managing dotfiles"

	commandInstallName  = "install"
	commandInstallUsage = "install user configs from dotfiles"

	commandUpdateName  = "update"
	commandUpdateUsage = "update dotfiles from user configs"

	commandDownloadName  = "download"
	commandDownloadUsage = "download configs from internet (theme for example)"

	commandCleanName  = "clean"
	commandCleanUsage = "clean unused dotfiles"

	commandDiffName  = "diff"
	commandDiffUsage = "diff dotfiles with user configs"

	commandValidateName = "validate"
	commonValidateUsage = "validate config"

	flagVerboseName  = "verbose"
	flagVerboseUsage = "show what is going on"

	flagDryRunName  = "dry-run"
	flagDryRunUsage = "demo mode without actually changing anything"

	flagAppName  = "app"
	flagAppUsage = "specific app to operate"

	currentDir = "."
)

var (
	installAliases  = []string{"ins"}
	updateAliases   = []string{"upd"}
	downloadAliases = []string{"dl"}
	cleanAliases    = []string{"cl"}
	diffAliases     = []string{"df"}
	validateAliases = []string{"vl"}
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
		Name:  name,
		Usage: usage,
		Commands: []*cli.Command{
			{
				Name:    commandInstallName,
				Aliases: installAliases,
				Usage:   commandInstallUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  flagVerboseName,
						Usage: flagVerboseUsage,
					},
					&cli.BoolFlag{
						Name:  flagDryRunName,
						Usage: flagDryRunUsage,
					},
					&cli.StringSliceFlag{
						Name:  flagAppName,
						Usage: flagAppUsage,
					},
				},
				Action: a.runInstall,
			},
			{
				Name:    commandUpdateName,
				Aliases: updateAliases,
				Usage:   commandUpdateUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  flagVerboseName,
						Usage: flagVerboseUsage,
					},
					&cli.BoolFlag{
						Name:  flagDryRunName,
						Usage: flagDryRunUsage,
					},
					&cli.StringSliceFlag{
						Name:  flagAppName,
						Usage: flagAppUsage,
					},
				},
				Action: a.runUpdate,
			},
			{
				Name:    commandDownloadName,
				Aliases: downloadAliases,
				Usage:   commandDownloadUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  flagVerboseName,
						Usage: flagVerboseUsage,
					},
					&cli.BoolFlag{
						Name:  flagDryRunName,
						Usage: flagDryRunUsage,
					},
					&cli.StringSliceFlag{
						Name:  flagAppName,
						Usage: flagAppUsage,
					},
				},
				Action: a.runDownload,
			},
			{
				Name:    commandCleanName,
				Aliases: cleanAliases,
				Usage:   commandCleanUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  flagVerboseName,
						Usage: flagVerboseUsage,
					},
					&cli.BoolFlag{
						Name:  flagDryRunName,
						Usage: flagDryRunUsage,
					},
				},
				Action: a.runClean,
			},
			{
				Name:    commandDiffName,
				Aliases: diffAliases,
				Usage:   commandDiffUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  flagVerboseName,
						Usage: flagVerboseUsage,
					},
					&cli.StringSliceFlag{
						Name:  flagAppName,
						Usage: flagAppUsage,
					},
				},
				Action: a.runDiff,
			},
			{
				Name:    commandValidateName,
				Aliases: validateAliases,
				Usage:   commonValidateUsage,
				Flags: []cli.Flag{
					&cli.BoolFlag{
						Name:  flagVerboseName,
						Usage: flagVerboseUsage,
					},
					&cli.StringSliceFlag{
						Name:  flagAppName,
						Usage: flagAppUsage,
					},
				},
				Action: a.runValidate,
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
		color.PrintAppError(name, fmt.Sprintf("OS [%s] is not supported right now", runtime.GOOS))
		return
	}

	if err := a.cliApp.Run(os.Args); err != nil {
		color.PrintAppError(name, err.Error())
	}
}

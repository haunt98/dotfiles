package config

import "fmt"

type ConfigDemo struct {
	ConfigApps
}

var _ Config = (*ConfigDemo)(nil)

func (c *ConfigDemo) Install(appNames ...string) error {
	mAppNames := slice2map(appNames)

	for appName, app := range c.Apps {
		if len(appNames) > 0 {
			if _, ok := mAppNames[appName]; !ok {
				continue
			}
		}

		for _, p := range app.Paths {
			if p.External == "" {
				continue
			}

			fmt.Printf("Replace [%s] -> [%s]\n", p.Internal, p.External)
		}
	}

	return nil
}

func (c *ConfigDemo) Update(appNames ...string) error {
	mAppNames := slice2map(appNames)

	for appName, app := range c.Apps {
		if len(appNames) > 0 {
			if _, ok := mAppNames[appName]; !ok {
				continue
			}
		}

		for _, p := range app.Paths {
			if p.External == "" {
				continue
			}

			fmt.Printf("Replace [%s] -> [%s]\n", p.External, p.Internal)
		}
	}

	return nil
}

func (c *ConfigDemo) Download(appNames ...string) error {
	mAppNames := slice2map(appNames)

	for appName, app := range c.Apps {
		if len(appNames) > 0 {
			if _, ok := mAppNames[appName]; !ok {
				continue
			}
		}

		for _, p := range app.Paths {
			if p.URL == "" {
				continue
			}

			fmt.Printf("Download [%s] -> [%s]\n", p.URL, p.Internal)
		}
	}

	return nil
}

func (c *ConfigDemo) Clean() error {
	unusedDirs, err := getUnusedDirs(c.Apps)
	if err != nil {
		return err
	}

	for dir := range unusedDirs {
		fmt.Printf("Remove [%s]\n", dir)
	}

	return nil
}

func (c *ConfigDemo) Diff(_ ...string) error {
	return nil
}

func (c *ConfigDemo) Validate(_ ...string) error {
	return nil
}

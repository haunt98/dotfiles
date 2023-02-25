package config

import "fmt"

type ConfigDemo struct {
	ConfigApps
}

var _ Config = (*ConfigDemo)(nil)

func (c *ConfigDemo) Install() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if p.External == "" {
				continue
			}

			fmt.Printf("Replace [%s] -> [%s]\n", p.Internal, p.External)
		}
	}

	return nil
}

func (c *ConfigDemo) Update() error {
	for _, app := range c.Apps {
		for _, p := range app.Paths {
			if p.External == "" {
				continue
			}

			fmt.Printf("Replace [%s] -> [%s]\n", p.External, p.Internal)
		}
	}

	return nil
}

func (c *ConfigDemo) Download() error {
	for _, app := range c.Apps {
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

func (c *ConfigDemo) Diff() error {
	return nil
}

func (c *ConfigDemo) Validate() error {
	return nil
}

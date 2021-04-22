package config

import "fmt"

type configDemo struct {
	configApps
}

var _ Config = (*configDemo)(nil)

func (cd *configDemo) Install() error {
	for _, app := range cd.Apps {
		for _, p := range app.Paths {
			fmt.Printf("Replace src %s dst %s\n", p.Internal, p.External)
		}
	}

	return nil
}

func (cd *configDemo) Update() error {
	for _, app := range cd.Apps {
		for _, p := range app.Paths {
			fmt.Printf("Replace src %s dst %s\n", p.External, p.Internal)
		}
	}

	return nil
}

func (cd *configDemo) Clean() error {
	return nil
}

package config

import "fmt"

type configDemo struct {
	configApps
}

var _ Config = (*configDemo)(nil)

func (cd *configDemo) Install() error {
	for _, app := range cd.Apps {
		for _, p := range app.Paths {
			fmt.Printf("Replace %s -> %s\n", p.Internal, p.External)
		}
	}

	return nil
}

func (cd *configDemo) Update() error {
	for _, app := range cd.Apps {
		for _, p := range app.Paths {
			fmt.Printf("Replace %s -> %s\n", p.External, p.Internal)
		}
	}

	return nil
}

func (cd *configDemo) Clean() error {
	unusedDirs, err := getUnusedDirs(cd.Apps)
	if err != nil {
		return err
	}

	for dir := range unusedDirs {
		fmt.Printf("Remove %s\n", dir)
	}

	return nil
}

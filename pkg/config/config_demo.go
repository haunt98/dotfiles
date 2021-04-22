package config

type configDemo struct {
	configApps
}

var _ Config = (*configDemo)(nil)

func (cd *configDemo) Install() error {
	return nil
}

func (cd *configDemo) Update() error {
	return nil
}

func (cd *configDemo) Clean() error {
	return nil
}

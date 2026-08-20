package config

type ConfigApps struct {
	Apps       map[string]App `json:"apps" toml:"apps"`
	SortedApps []string       `json:"-" toml:"-"`
}

// Read from file
type App struct {
	Paths []Path `json:"paths" toml:"paths"`
}

type Path struct {
	Internal string `json:"internal" toml:"internal"`
	External string `json:"external,omitempty" toml:"external"`
}

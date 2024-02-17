package config

type ConfigApps struct {
	Apps map[string]App `json:"apps" toml:"apps"`
	// Sort version
	Apps2 []string `json:"-" toml:"-"`
}

// Read from file
type App struct {
	Paths []Path `json:"paths" toml:"paths"`
}

type Path struct {
	Internal string `json:"internal" toml:"internal"`
	External string `json:"external,omitempty" toml:"external"`
	URL      string `json:"url,omitempty" toml:"url"`
}

// Helper
func slice2map(vs []string) map[string]struct{} {
	m := make(map[string]struct{}, len(vs))
	for _, v := range vs {
		m[v] = struct{}{}
	}
	return m
}

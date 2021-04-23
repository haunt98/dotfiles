package config

type Config interface {
	Install() error
	Update() error
	Clean() error
	Compare() error
}

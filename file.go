package main

import "os"

func Delete(path string) error {
	return os.RemoveAll(path)
}

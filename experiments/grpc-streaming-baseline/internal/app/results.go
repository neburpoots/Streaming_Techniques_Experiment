package app

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

func WriteJSON(dir, fileName string, value any) error {
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return fmt.Errorf("create result dir: %w", err)
	}
	path := filepath.Join(dir, fileName)
	file, err := os.Create(path)
	if err != nil {
		return fmt.Errorf("create %s: %w", path, err)
	}
	defer file.Close()

	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(value); err != nil {
		return fmt.Errorf("encode %s: %w", path, err)
	}
	return nil
}

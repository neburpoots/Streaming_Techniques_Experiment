package workload

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

type CSVReplaySource struct {
	payloads            [][]byte
	nominalPayloadBytes int
	descriptor          string
}

func NewCSVReplaySource(datasetDir string, datasetFiles []string, rowsPerMessage, repeatCount int) (*CSVReplaySource, error) {
	if len(datasetFiles) == 0 {
		return nil, fmt.Errorf("csv replay requires at least one dataset file")
	}
	if rowsPerMessage <= 0 {
		rowsPerMessage = 1
	}
	if repeatCount <= 0 {
		repeatCount = 1
	}

	rows := make([]string, 0)
	cleanNames := make([]string, 0, len(datasetFiles))
	for _, name := range datasetFiles {
		trimmed := strings.TrimSpace(name)
		if trimmed == "" {
			continue
		}
		path := trimmed
		if !filepath.IsAbs(path) {
			path = filepath.Join(datasetDir, trimmed)
		}
		fileRows, err := readCSVRows(path)
		if err != nil {
			return nil, err
		}
		rows = append(rows, fileRows...)
		cleanNames = append(cleanNames, filepath.Base(trimmed))
	}
	if len(rows) == 0 {
		return nil, fmt.Errorf("csv replay found no data rows to use")
	}

	batches := make([][]byte, 0, (len(rows)+rowsPerMessage-1)/rowsPerMessage)
	for start := 0; start < len(rows); start += rowsPerMessage {
		end := start + rowsPerMessage
		if end > len(rows) {
			end = len(rows)
		}
		batch := strings.Join(rows[start:end], "\n")
		batches = append(batches, []byte(batch))
	}

	payloads := make([][]byte, 0, len(batches)*repeatCount)
	totalBytes := 0
	for i := 0; i < repeatCount; i++ {
		for _, batch := range batches {
			copied := make([]byte, len(batch))
			copy(copied, batch)
			payloads = append(payloads, copied)
			totalBytes += len(copied)
		}
	}
	if len(payloads) == 0 {
		return nil, fmt.Errorf("csv replay produced no payload batches")
	}

	return &CSVReplaySource{
		payloads:            payloads,
		nominalPayloadBytes: totalBytes / len(payloads),
		descriptor:          fmt.Sprintf("csv-replay[%s]:rows-per-message=%d:repeat=%d", strings.Join(cleanNames, "+"), rowsPerMessage, repeatCount),
	}, nil
}

func (s *CSVReplaySource) Payload(sequence uint64) []byte {
	if len(s.payloads) == 0 {
		return nil
	}
	index := int((sequence - 1) % uint64(len(s.payloads)))
	payload := s.payloads[index]
	copyBuf := make([]byte, len(payload))
	copy(copyBuf, payload)
	return copyBuf
}

func (s *CSVReplaySource) NominalPayloadBytes() int {
	return s.nominalPayloadBytes
}

func (s *CSVReplaySource) Descriptor() string {
	return s.descriptor
}

func readCSVRows(path string) ([]string, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("read dataset %s: %w", path, err)
	}
	normalized := strings.ReplaceAll(string(data), "\r\n", "\n")
	normalized = strings.ReplaceAll(normalized, "\r", "\n")
	lines := strings.Split(normalized, "\n")
	rows := make([]string, 0, len(lines))
	headerSkipped := false
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if trimmed == "" {
			continue
		}
		if !headerSkipped {
			headerSkipped = true
			continue
		}
		rows = append(rows, trimmed)
	}
	return rows, nil
}
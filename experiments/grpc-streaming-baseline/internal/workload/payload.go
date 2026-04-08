package workload

import "encoding/binary"

type Source interface {
	Payload(sequence uint64) []byte
	NominalPayloadBytes() int
	Descriptor() string
}

type SyntheticSource struct {
	size int
}

func NewSyntheticSource(size int) *SyntheticSource {
	return &SyntheticSource{size: size}
}

func (s *SyntheticSource) Payload(sequence uint64) []byte {
	return Payload(sequence, s.size)
}

func (s *SyntheticSource) NominalPayloadBytes() int {
	return s.size
}

func (s *SyntheticSource) Descriptor() string {
	return "synthetic"
}

func Payload(sequence uint64, size int) []byte {
	if size <= 0 {
		return nil
	}
	data := make([]byte, size)
	for offset := 0; offset < size; offset += 8 {
		value := sequence + uint64(offset)
		remaining := size - offset
		if remaining >= 8 {
			binary.LittleEndian.PutUint64(data[offset:offset+8], value)
			continue
		}
		buffer := make([]byte, 8)
		binary.LittleEndian.PutUint64(buffer, value)
		copy(data[offset:], buffer[:remaining])
	}
	return data
}

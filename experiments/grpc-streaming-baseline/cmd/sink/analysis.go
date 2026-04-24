package main

import pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"

type sinkArrivalEvent struct {
	ArrivalAtUnixNano int64   `json:"arrival_at_unix_nano"`
	LatencyMs         float64 `json:"latency_ms"`
}

type sinkAnalysisFile struct {
	RunId                    string             `json:"run_id"`
	TransportMode            string             `json:"transport_mode"`
	RegisteredAtUnixNano     int64              `json:"registered_at_unix_nano"`
	StartedAtUnixNano        int64              `json:"started_at_unix_nano"`
	FinishedAtUnixNano       int64              `json:"finished_at_unix_nano"`
	ExpectedMessages         uint64             `json:"expected_messages"`
	TargetMessagesPerSecond  uint64             `json:"target_messages_per_second"`
	UniqueEvents             []sinkArrivalEvent `json:"unique_events,omitempty"`
	DuplicateArrivalUnixNano []int64            `json:"duplicate_arrival_unix_nanos,omitempty"`
}

func newSinkAnalysis(runID string, cfg *pb.RunConfig, registeredAtUnixNano int64) *sinkAnalysisFile {
	if cfg == nil || cfg.GetTargetMessagesPerSecond() == 0 {
		return nil
	}

	capacity := int(cfg.GetExpectedTotalMessages())
	if capacity < 0 {
		capacity = 0
	}

	duplicateCapacity := capacity / 8
	if duplicateCapacity < 16 {
		duplicateCapacity = 16
	}

	return &sinkAnalysisFile{
		RunId:                    runID,
		TransportMode:            cfg.GetTransportMode(),
		RegisteredAtUnixNano:     registeredAtUnixNano,
		ExpectedMessages:         cfg.GetExpectedTotalMessages(),
		TargetMessagesPerSecond:  cfg.GetTargetMessagesPerSecond(),
		UniqueEvents:             make([]sinkArrivalEvent, 0, capacity),
		DuplicateArrivalUnixNano: make([]int64, 0, duplicateCapacity),
	}
}
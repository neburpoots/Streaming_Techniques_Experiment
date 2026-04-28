package main

import (
	"context"
	"fmt"
	"log"
	"time"

	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/transport"
)

func (s *sinkServer) startNATSRunConsumers(runCtx context.Context, runConfig *pb.RunConfig) {
	for worker := 0; worker < int(runConfig.GetConcurrency()); worker++ {
		worker := worker
		go func() {
			s.runNATSSinkWorker(runCtx, runConfig.GetRunId(), worker)
		}()
	}
}

func (s *sinkServer) runNATSSinkWorker(ctx context.Context, runID string, worker int) {
	for {
		if err := s.consumeNATSRunWorker(ctx, runID, worker); err != nil {
			if ctx.Err() != nil {
				return
			}
			log.Printf("nats sink worker %d for run %s restarting after error: %v", worker, runID, err)
			if err := waitForSinkBrokerRetry(ctx); err != nil {
				return
			}
			continue
		}
		return
	}
}

func (s *sinkServer) consumeNATSRunWorker(ctx context.Context, runID string, worker int) error {
	streamName := s.nats.TransformerToSinkRunWorkerStream(runID, worker)
	subject := s.nats.TransformerToSinkRunWorkerSubject(runID, worker)
	consumer, err := transport.NewNATSJetStreamConsumer(s.nats, streamName, subject, s.nats.ConsumerName("sink", runID, worker))
	if err != nil {
		return err
	}
	defer func() {
		_ = consumer.Close()
	}()

	s.metrics.streams.Inc()

	for {
		chunk, delivery, err := consumer.ReceiveChunk(ctx)
		if err != nil {
			return err
		}
		if err := s.ingest(chunk); err != nil {
			return fmt.Errorf("ingest worker %d sequence %d from %s: %w", worker, chunk.GetSequence(), subject, err)
		}
		if err := delivery.Commit(); err != nil {
			return fmt.Errorf("ack worker %d sequence %d from %s: %w", worker, chunk.GetSequence(), subject, err)
		}
	}
}

func waitForSinkBrokerRetry(ctx context.Context) error {
	timer := time.NewTimer(1 * time.Second)
	defer timer.Stop()
	select {
	case <-ctx.Done():
		return ctx.Err()
	case <-timer.C:
		return nil
	}
}

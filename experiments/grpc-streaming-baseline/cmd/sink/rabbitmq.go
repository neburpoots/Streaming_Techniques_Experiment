package main

import (
	"context"
	"fmt"
	"log"
	"time"

	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/transport"
)

func (s *sinkServer) startRabbitMQRunConsumers(runCtx context.Context, runConfig *pb.RunConfig) {
	for worker := 0; worker < int(runConfig.GetConcurrency()); worker++ {
		worker := worker
		go func() {
			s.runRabbitMQSinkWorker(runCtx, runConfig.GetRunId(), worker)
		}()
	}
}

func (s *sinkServer) runRabbitMQSinkWorker(ctx context.Context, runID string, worker int) {
	for {
		if err := s.consumeRabbitMQRunWorker(ctx, runID, worker); err != nil {
			if ctx.Err() != nil {
				return
			}
			log.Printf("rabbitmq sink worker %d for run %s restarting after error: %v", worker, runID, err)
			if err := waitForRabbitMQSinkRetry(ctx); err != nil {
				return
			}
			continue
		}
		return
	}
}

func (s *sinkServer) consumeRabbitMQRunWorker(ctx context.Context, runID string, worker int) error {
	streamName := s.rabbitMQ.TransformerToSinkRunWorkerStream(runID, worker)
	consumer, err := transport.NewRabbitMQStreamConsumer(s.rabbitMQ, streamName, fmt.Sprintf("sink-%s-%02d", runID, worker))
	if err != nil {
		return err
	}
	defer func() {
		_ = consumer.Close()
	}()

	s.metrics.streams.Inc()

	for {
		chunk, _, err := consumer.ReceiveChunk(ctx)
		if err != nil {
			return err
		}
		if err := s.ingest(chunk); err != nil {
			return fmt.Errorf("ingest worker %d sequence %d from %s: %w", worker, chunk.GetSequence(), streamName, err)
		}
	}
}

func waitForRabbitMQSinkRetry(ctx context.Context) error {
	timer := time.NewTimer(1 * time.Second)
	defer timer.Stop()
	select {
	case <-ctx.Done():
		return ctx.Err()
	case <-timer.C:
		return nil
	}
}

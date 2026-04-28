package main

import (
	"context"
	"fmt"
	"log"

	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/transport"
)

func (s *sinkServer) startKafkaRunConsumers(runCtx context.Context, runConfig *pb.RunConfig) {
	for worker := 0; worker < int(runConfig.GetConcurrency()); worker++ {
		worker := worker
		go func() {
			s.runKafkaSinkWorker(runCtx, runConfig.GetRunId(), worker)
		}()
	}
}

func (s *sinkServer) runKafkaSinkWorker(ctx context.Context, runID string, worker int) {
	for {
		if err := s.consumeKafkaRunWorker(ctx, runID, worker); err != nil {
			if ctx.Err() != nil {
				return
			}
			log.Printf("kafka sink worker %d for run %s restarting after error: %v", worker, runID, err)
			if err := waitForSinkBrokerRetry(ctx); err != nil {
				return
			}
			continue
		}
		return
	}
}

func (s *sinkServer) consumeKafkaRunWorker(ctx context.Context, runID string, worker int) error {
	topic := s.kafka.TransformerToSinkRunTopic(runID)
	consumer, err := transport.NewKafkaConsumer(s.kafka, topic, s.kafka.ConsumerGroup("sink", runID))
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
			return fmt.Errorf("ingest worker %d sequence %d from %s: %w", worker, chunk.GetSequence(), topic, err)
		}
		if err := delivery.Commit(); err != nil {
			return fmt.Errorf("commit worker %d sequence %d from %s: %w", worker, chunk.GetSequence(), topic, err)
		}
	}
}

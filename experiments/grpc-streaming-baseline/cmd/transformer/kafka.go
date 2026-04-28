package main

import (
	"context"
	"fmt"
	"log"

	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/transport"
)

func startKafkaBridge(ctx context.Context, server *transformerServer, cfg *transformerConfig) {
	for worker := 0; worker < cfg.concurrency; worker++ {
		worker := worker
		go func() {
			runKafkaBridgeWorker(ctx, server, cfg, worker)
		}()
	}
}

func runKafkaBridgeWorker(ctx context.Context, server *transformerServer, cfg *transformerConfig, worker int) {
	for {
		if err := bridgeKafkaWorker(ctx, server, cfg, worker); err != nil {
			if ctx.Err() != nil {
				return
			}
			log.Printf("kafka bridge worker %d restarting after error: %v", worker, err)
			if err := waitForBrokerRetry(ctx); err != nil {
				return
			}
			continue
		}
		return
	}
}

func bridgeKafkaWorker(ctx context.Context, server *transformerServer, cfg *transformerConfig, worker int) error {
	inputTopic := cfg.kafka.ProducerToTransformerRunTopic(cfg.runID)
	outputTopic := cfg.kafka.TransformerToSinkRunTopic(cfg.runID)
	consumer, err := transport.NewKafkaConsumer(cfg.kafka, inputTopic, cfg.kafka.ConsumerGroup("transformer", cfg.runID))
	if err != nil {
		return err
	}
	defer func() {
		_ = consumer.Close()
	}()

	publisher, err := transport.NewKafkaPublisher(cfg.kafka, outputTopic)
	if err != nil {
		return err
	}
	defer func() {
		_ = publisher.Close()
	}()

	server.metrics.streams.Inc()

	for {
		chunk, delivery, err := consumer.ReceiveChunk(ctx)
		if err != nil {
			return err
		}

		server.applyWork(chunk.GetPayload())
		if err := publisher.PublishChunk(ctx, chunk); err != nil {
			return fmt.Errorf("publish worker %d sequence %d to %s: %w", worker, chunk.GetSequence(), outputTopic, err)
		}
		if err := delivery.Commit(); err != nil {
			return fmt.Errorf("commit worker %d sequence %d from %s: %w", worker, chunk.GetSequence(), inputTopic, err)
		}

		server.metrics.messages.Inc()
		server.metrics.bytes.Add(float64(len(chunk.GetPayload())))
	}
}

package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/transport"
)

func startRabbitMQBridge(ctx context.Context, server *transformerServer, cfg *transformerConfig) {
	for worker := 0; worker < cfg.concurrency; worker++ {
		worker := worker
		go func() {
			runRabbitMQBridgeWorker(ctx, server, cfg, worker)
		}()
	}
}

func runRabbitMQBridgeWorker(ctx context.Context, server *transformerServer, cfg *transformerConfig, worker int) {
	for {
		if err := bridgeRabbitMQWorker(ctx, server, cfg, worker); err != nil {
			if ctx.Err() != nil {
				return
			}
			log.Printf("rabbitmq bridge worker %d restarting after error: %v", worker, err)
			if err := waitForRabbitMQRetry(ctx); err != nil {
				return
			}
			continue
		}
		return
	}
}

func bridgeRabbitMQWorker(ctx context.Context, server *transformerServer, cfg *transformerConfig, worker int) error {
	inputStream := cfg.rabbitMQ.ProducerToTransformerRunWorkerStream(cfg.runID, worker)
	outputStream := cfg.rabbitMQ.TransformerToSinkRunWorkerStream(cfg.runID, worker)
	consumer, err := transport.NewRabbitMQStreamConsumer(cfg.rabbitMQ, inputStream, fmt.Sprintf("transformer-%s-%02d", cfg.runID, worker))
	if err != nil {
		return err
	}
	defer func() {
		_ = consumer.Close()
	}()

	publisher, err := transport.NewRabbitMQStreamPublisher(cfg.rabbitMQ, outputStream)
	if err != nil {
		return err
	}
	defer func() {
		_ = publisher.Close()
	}()

	server.metrics.streams.Inc()

	for {
		chunk, _, err := consumer.ReceiveChunk(ctx)
		if err != nil {
			return err
		}

		server.applyWork(chunk.GetPayload())
		if err := publisher.PublishChunk(ctx, chunk); err != nil {
			return fmt.Errorf("publish worker %d sequence %d to %s: %w", worker, chunk.GetSequence(), outputStream, err)
		}

		server.metrics.messages.Inc()
		server.metrics.bytes.Add(float64(len(chunk.GetPayload())))
	}
}

func waitForRabbitMQRetry(ctx context.Context) error {
	timer := time.NewTimer(1 * time.Second)
	defer timer.Stop()
	select {
	case <-ctx.Done():
		return ctx.Err()
	case <-timer.C:
		return nil
	}
}

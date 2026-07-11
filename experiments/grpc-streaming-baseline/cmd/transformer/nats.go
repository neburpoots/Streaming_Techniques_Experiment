package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/transport"
)

func startNATSBridge(ctx context.Context, server *transformerServer, cfg *transformerConfig) {
	for worker := 0; worker < cfg.concurrency; worker++ {
		worker := worker
		go func() {
			runNATSBridgeWorker(ctx, server, cfg, worker)
		}()
	}
}

func runNATSBridgeWorker(ctx context.Context, server *transformerServer, cfg *transformerConfig, worker int) {
	for {
		if err := bridgeNATSWorker(ctx, server, cfg, worker); err != nil {
			if ctx.Err() != nil {
				return
			}
			log.Printf("nats bridge worker %d restarting after error: %v", worker, err)
			if err := waitForBrokerRetry(ctx); err != nil {
				return
			}
			continue
		}
		return
	}
}

func bridgeNATSWorker(ctx context.Context, server *transformerServer, cfg *transformerConfig, worker int) error {
	inputStream := cfg.nats.ProducerToTransformerRunWorkerStream(cfg.runID, worker)
	inputSubject := cfg.nats.ProducerToTransformerRunWorkerSubject(cfg.runID, worker)
	outputStream := cfg.nats.TransformerToSinkRunWorkerStream(cfg.runID, worker)
	outputSubject := cfg.nats.TransformerToSinkRunWorkerSubject(cfg.runID, worker)
	consumer, err := transport.NewNATSJetStreamConsumer(cfg.nats, inputStream, inputSubject, cfg.nats.ConsumerName("transformer", cfg.runID, worker))
	if err != nil {
		return err
	}
	defer func() {
		_ = consumer.Close()
	}()

	publisher, err := transport.NewNATSJetStreamPublisher(cfg.nats, outputStream, outputSubject)
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

		server.recordNATSInputDelivery(chunk, delivery)
		server.applyWork(chunk.GetPayload())
		if err := publisher.PublishChunk(ctx, chunk); err != nil {
			return fmt.Errorf("publish worker %d sequence %d to %s: %w", worker, chunk.GetSequence(), outputSubject, err)
		}
		if err := delivery.Commit(); err != nil {
			return fmt.Errorf("ack worker %d sequence %d from %s: %w", worker, chunk.GetSequence(), inputSubject, err)
		}

		server.metrics.messages.Inc()
		server.metrics.bytes.Add(float64(len(chunk.GetPayload())))
	}
}

func waitForBrokerRetry(ctx context.Context) error {
	timer := time.NewTimer(1 * time.Second)
	defer timer.Stop()
	select {
	case <-ctx.Done():
		return ctx.Err()
	case <-timer.C:
		return nil
	}
}

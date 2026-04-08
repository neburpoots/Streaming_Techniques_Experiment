package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strings"
	"sync"
	"syscall"
	"time"

	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/app"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/config"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/workload"
	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"golang.org/x/time/rate"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type producerConfig struct {
	runID                    string
	transportMode            string
	workloadSource           string
	transformerAddr          string
	sinkAdminAddr            string
	resultDir                string
	profile                  string
	expectedTotalMessages    uint64
	payloadBytes             int
	datasetDir               string
	datasetFiles             string
	datasetRowsPerMessage    int
	datasetRepeatCount       int
	concurrency              int
	targetMessagesPerSecond  int
	transformerWorkIterations uint64
	sinkProcessDelayMillis   uint64
	pollInterval             time.Duration
	maxSummaryWait           time.Duration
}

type producerResult struct {
	RunID             string          `json:"run_id"`
	TransportMode     string          `json:"transport_mode"`
	WorkloadSource    string          `json:"workload_source"`
	WorkloadDescriptor string         `json:"workload_descriptor"`
	Profile           string          `json:"profile"`
	ExpectedMessages  uint64          `json:"expected_messages"`
	PayloadBytes      int             `json:"payload_bytes"`
	Concurrency       int             `json:"concurrency"`
	TargetMessagesPerSecond int       `json:"target_messages_per_second"`
	ProducerStartedAt string          `json:"producer_started_at"`
	ProducerFinishedAt string         `json:"producer_finished_at"`
	StreamAcks        []*pb.StreamAck `json:"stream_acks"`
	UnaryAcknowledgedRequests uint64  `json:"unary_acknowledged_requests"`
	SinkSummary       *pb.RunSummary  `json:"sink_summary"`
}

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer cancel()

	cfg, err := loadConfig()
	if err != nil {
		log.Fatalf("load config: %v", err)
	}

	payloadSource, err := loadPayloadSource(cfg)
	if err != nil {
		log.Fatalf("load workload source: %v", err)
	}

	producerConn, err := grpc.NewClient(cfg.transformerAddr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("connect transformer: %v", err)
	}
	defer producerConn.Close()

	adminConn, err := grpc.NewClient(cfg.sinkAdminAddr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("connect sink admin: %v", err)
	}
	defer adminConn.Close()

	transformerClient := pb.NewTransformerClient(producerConn)
	adminClient := pb.NewExperimentAdminClient(adminConn)

	registeredAt := time.Now()
	_, err = adminClient.RegisterRun(ctx, &pb.RunConfig{
		RunId:                    cfg.runID,
		Profile:                  cfg.profile,
		ExpectedTotalMessages:    cfg.expectedTotalMessages,
		PayloadBytes:             uint64(payloadSource.NominalPayloadBytes()),
		Concurrency:              uint64(cfg.concurrency),
		TargetMessagesPerSecond:  uint64(cfg.targetMessagesPerSecond),
		TransformerWorkIterations: cfg.transformerWorkIterations,
		SinkProcessDelayMs:       cfg.sinkProcessDelayMillis,
		RegisteredAtUnixNano:     registeredAt.UnixNano(),
		TransportMode:            cfg.transportMode,
	})
	if err != nil {
		log.Fatalf("register run: %v", err)
	}

	var limiter *rate.Limiter
	if cfg.targetMessagesPerSecond > 0 {
		limiter = rate.NewLimiter(rate.Limit(cfg.targetMessagesPerSecond), maxInt(1, cfg.targetMessagesPerSecond))
	}

	startedAt := time.Now()
	acks, unaryAckCount, err := runTransport(ctx, transformerClient, cfg, limiter, payloadSource)
	if err != nil {
		log.Fatalf("run %s workload: %v", cfg.transportMode, err)
	}

	summary, err := waitForSummary(ctx, adminClient, cfg)
	if err != nil {
		log.Fatalf("wait for sink summary: %v", err)
	}

	result := producerResult{
		RunID:                    cfg.runID,
		TransportMode:            cfg.transportMode,
		WorkloadSource:           cfg.workloadSource,
		WorkloadDescriptor:       payloadSource.Descriptor(),
		Profile:                  cfg.profile,
		ExpectedMessages:         cfg.expectedTotalMessages,
		PayloadBytes:             payloadSource.NominalPayloadBytes(),
		Concurrency:              cfg.concurrency,
		TargetMessagesPerSecond:  cfg.targetMessagesPerSecond,
		ProducerStartedAt:        startedAt.UTC().Format(time.RFC3339Nano),
		ProducerFinishedAt:       time.Now().UTC().Format(time.RFC3339Nano),
		StreamAcks:               acks,
		UnaryAcknowledgedRequests: unaryAckCount,
		SinkSummary:              summary,
	}

	if err := app.WriteJSON(cfg.resultDir, fmt.Sprintf("%s-producer-result.json", cfg.runID), result); err != nil {
		log.Fatalf("write producer result: %v", err)
	}

	log.Printf("run %s completed: %.2f msg/s, p95 %.2f ms, p99 %.2f ms", summary.GetRunId(), summary.GetThroughputMessagesPerSecond(), summary.GetP95LatencyMs(), summary.GetP99LatencyMs())
}

func loadConfig() (*producerConfig, error) {
	expectedTotalMessages, err := config.Uint64("TOTAL_MESSAGES", 50000)
	if err != nil {
		return nil, err
	}
	payloadBytes, err := config.Int("PAYLOAD_BYTES", 1024)
	if err != nil {
		return nil, err
	}
	datasetRowsPerMessage, err := config.Int("DATASET_ROWS_PER_MESSAGE", 1)
	if err != nil {
		return nil, err
	}
	datasetRepeatCount, err := config.Int("DATASET_REPEAT_COUNT", 1)
	if err != nil {
		return nil, err
	}
	concurrency, err := config.Int("CONCURRENCY", 1)
	if err != nil {
		return nil, err
	}
	targetMessagesPerSecond, err := config.Int("TARGET_MESSAGES_PER_SECOND", 0)
	if err != nil {
		return nil, err
	}
	transformerWorkIterations, err := config.Uint64("TRANSFORMER_WORK_ITERATIONS", 0)
	if err != nil {
		return nil, err
	}
	sinkProcessDelayMillis, err := config.Uint64("SINK_PROCESS_DELAY_MS", 0)
	if err != nil {
		return nil, err
	}
	pollMillis, err := config.Int("SUMMARY_POLL_MILLISECONDS", 250)
	if err != nil {
		return nil, err
	}
	maxWaitSeconds, err := config.Int("MAX_SUMMARY_WAIT_SECONDS", 30)
	if err != nil {
		return nil, err
	}

	return &producerConfig{
		runID:                    config.String("RUN_ID", fmt.Sprintf("grpc-stream-%d", time.Now().Unix())),
		transportMode:            config.String("TRANSPORT_MODE", "client-streaming"),
		workloadSource:           config.String("WORKLOAD_SOURCE", "synthetic"),
		transformerAddr:          config.String("TRANSFORMER_ADDR", "localhost:50051"),
		sinkAdminAddr:            config.String("SINK_ADMIN_ADDR", "localhost:50052"),
		resultDir:                config.String("RESULT_DIR", "/results"),
		profile:                  config.String("PROFILE", "bulk"),
		expectedTotalMessages:    expectedTotalMessages,
		payloadBytes:             payloadBytes,
		datasetDir:               config.String("DATASET_DIR", "/datasets"),
		datasetFiles:             config.String("DATASET_FILES", ""),
		datasetRowsPerMessage:    datasetRowsPerMessage,
		datasetRepeatCount:       datasetRepeatCount,
		concurrency:              concurrency,
		targetMessagesPerSecond:  targetMessagesPerSecond,
		transformerWorkIterations: transformerWorkIterations,
		sinkProcessDelayMillis:   sinkProcessDelayMillis,
		pollInterval:             time.Duration(pollMillis) * time.Millisecond,
		maxSummaryWait:           time.Duration(maxWaitSeconds) * time.Second,
	}, nil
}

func loadPayloadSource(cfg *producerConfig) (workload.Source, error) {
	switch cfg.workloadSource {
	case "synthetic":
		return workload.NewSyntheticSource(cfg.payloadBytes), nil
	case "csv-replay":
		return workload.NewCSVReplaySource(cfg.datasetDir, splitCSVList(cfg.datasetFiles), cfg.datasetRowsPerMessage, cfg.datasetRepeatCount)
	default:
		return nil, fmt.Errorf("unsupported WORKLOAD_SOURCE %q", cfg.workloadSource)
	}
}

func splitCSVList(value string) []string {
	parts := strings.Split(value, ",")
	results := make([]string, 0, len(parts))
	for _, part := range parts {
		trimmed := strings.TrimSpace(part)
		if trimmed != "" {
			results = append(results, trimmed)
		}
	}
	return results
}

func runTransport(ctx context.Context, client pb.TransformerClient, cfg *producerConfig, limiter *rate.Limiter, payloadSource workload.Source) ([]*pb.StreamAck, uint64, error) {
	switch cfg.transportMode {
	case "client-streaming":
		acks, err := sendBulkStreaming(ctx, client, cfg, limiter, payloadSource)
		return acks, 0, err
	case "unary":
		count, err := sendBulkUnary(ctx, client, cfg, limiter, payloadSource)
		return nil, count, err
	default:
		return nil, 0, fmt.Errorf("unsupported TRANSPORT_MODE %q", cfg.transportMode)
	}
}

func sendBulkStreaming(ctx context.Context, client pb.TransformerClient, cfg *producerConfig, limiter *rate.Limiter, payloadSource workload.Source) ([]*pb.StreamAck, error) {
	ackChan := make(chan *pb.StreamAck, cfg.concurrency)
	errChan := make(chan error, cfg.concurrency)
	var wg sync.WaitGroup

	for worker := 0; worker < cfg.concurrency; worker++ {
		worker := worker
		wg.Add(1)
		go func() {
			defer wg.Done()

			stream, err := client.Push(ctx)
			if err != nil {
				errChan <- fmt.Errorf("worker %d open stream: %w", worker, err)
				return
			}

			for sequence := uint64(worker + 1); sequence <= cfg.expectedTotalMessages; sequence += uint64(cfg.concurrency) {
				if limiter != nil {
					if err := limiter.Wait(ctx); err != nil {
						errChan <- fmt.Errorf("worker %d rate limit: %w", worker, err)
						return
					}
				}
				chunk := &pb.DataChunk{
					RunId:             cfg.runID,
					Sequence:          sequence,
					ProducerWorker:    uint64(worker),
					CreatedAtUnixNano: time.Now().UnixNano(),
					Payload:           payloadSource.Payload(sequence),
				}
				if err := stream.Send(chunk); err != nil {
					errChan <- fmt.Errorf("worker %d send sequence %d: %w", worker, sequence, err)
					return
				}
			}

			ack, err := stream.CloseAndRecv()
			if err != nil {
				errChan <- fmt.Errorf("worker %d close stream: %w", worker, err)
				return
			}
			ackChan <- ack
		}()
	}

	wg.Wait()
	close(ackChan)
	close(errChan)

	for err := range errChan {
		if err != nil {
			return nil, err
		}
	}

	acks := make([]*pb.StreamAck, 0, cfg.concurrency)
	for ack := range ackChan {
		acks = append(acks, ack)
	}
	return acks, nil
}

func sendBulkUnary(ctx context.Context, client pb.TransformerClient, cfg *producerConfig, limiter *rate.Limiter, payloadSource workload.Source) (uint64, error) {
	ackChan := make(chan uint64, cfg.concurrency)
	errChan := make(chan error, cfg.concurrency)
	var wg sync.WaitGroup

	for worker := 0; worker < cfg.concurrency; worker++ {
		worker := worker
		wg.Add(1)
		go func() {
			defer wg.Done()
			var acknowledged uint64
			for sequence := uint64(worker + 1); sequence <= cfg.expectedTotalMessages; sequence += uint64(cfg.concurrency) {
				if limiter != nil {
					if err := limiter.Wait(ctx); err != nil {
						errChan <- fmt.Errorf("worker %d rate limit: %w", worker, err)
						return
					}
				}
				_, err := client.PushUnary(ctx, &pb.DataChunk{
					RunId:             cfg.runID,
					Sequence:          sequence,
					ProducerWorker:    uint64(worker),
					CreatedAtUnixNano: time.Now().UnixNano(),
					Payload:           payloadSource.Payload(sequence),
				})
				if err != nil {
					errChan <- fmt.Errorf("worker %d unary send sequence %d: %w", worker, sequence, err)
					return
				}
				acknowledged++
			}
			ackChan <- acknowledged
		}()
	}

	wg.Wait()
	close(ackChan)
	close(errChan)

	for err := range errChan {
		if err != nil {
			return 0, err
		}
	}

	var acknowledged uint64
	for count := range ackChan {
		acknowledged += count
	}
	return acknowledged, nil
}

func waitForSummary(ctx context.Context, client pb.ExperimentAdminClient, cfg *producerConfig) (*pb.RunSummary, error) {
	deadline := time.Now().Add(cfg.maxSummaryWait)
	for time.Now().Before(deadline) {
		summary, err := client.GetRunSummary(ctx, &pb.RunQuery{RunId: cfg.runID})
		if err == nil && summary.GetCompleted() {
			return summary, nil
		}
		if err != nil {
			statusErr, ok := status.FromError(err)
			if !ok || statusErr.Code() != codes.NotFound {
				return nil, err
			}
		}
		select {
		case <-ctx.Done():
			return nil, ctx.Err()
		case <-time.After(cfg.pollInterval):
		}
	}
	return nil, fmt.Errorf("timed out waiting for sink summary after %s", cfg.maxSummaryWait)
}

func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}

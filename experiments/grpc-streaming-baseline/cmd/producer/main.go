package main

import (
	"context"
	"errors"
	"fmt"
	"io"
	"log"
	"os"
	"os/signal"
	"strings"
	"sync"
	"syscall"
	"time"

	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/app"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/config"
	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/workload"
	"golang.org/x/time/rate"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/status"
)

type producerConfig struct {
	runID                     string
	transportMode             string
	workloadSource            string
	transformerAddr           string
	sinkAdminAddr             string
	resultDir                 string
	profile                   string
	expectedTotalMessages     uint64
	payloadBytes              int
	datasetDir                string
	datasetFiles              string
	datasetRowsPerMessage     int
	datasetRepeatCount        int
	concurrency               int
	targetMessagesPerSecond   int
	transformerWorkIterations uint64
	sinkProcessDelayMillis    uint64
	maxRetryAttempts          int
	retryBackoff              time.Duration
	failureAction             string
	failureTarget             string
	failureAfterSeconds       int
	pollInterval              time.Duration
	maxSummaryWait            time.Duration
}

type producerDiagnostics struct {
	mu                sync.Mutex
	retryAttempts     uint64
	streamReconnects  uint64
	recoveryDurations []float64
}

func (d *producerDiagnostics) recordRetry() {
	d.mu.Lock()
	defer d.mu.Unlock()
	d.retryAttempts++
}

func (d *producerDiagnostics) recordStreamReconnect() {
	d.mu.Lock()
	defer d.mu.Unlock()
	d.streamReconnects++
}

func (d *producerDiagnostics) recordRecovery(duration time.Duration) {
	d.mu.Lock()
	defer d.mu.Unlock()
	d.recoveryDurations = append(d.recoveryDurations, float64(duration)/float64(time.Millisecond))
}

func (d *producerDiagnostics) snapshot() (uint64, uint64, int, float64, float64) {
	d.mu.Lock()
	defer d.mu.Unlock()
	if len(d.recoveryDurations) == 0 {
		return d.retryAttempts, d.streamReconnects, 0, 0, 0
	}
	var total float64
	max := d.recoveryDurations[0]
	for _, duration := range d.recoveryDurations {
		total += duration
		if duration > max {
			max = duration
		}
	}
	return d.retryAttempts, d.streamReconnects, len(d.recoveryDurations), total / float64(len(d.recoveryDurations)), max
}

type producerResult struct {
	RunID                     string          `json:"run_id"`
	TransportMode             string          `json:"transport_mode"`
	WorkloadSource            string          `json:"workload_source"`
	WorkloadDescriptor        string          `json:"workload_descriptor"`
	Profile                   string          `json:"profile"`
	ExpectedMessages          uint64          `json:"expected_messages"`
	PayloadBytes              int             `json:"payload_bytes"`
	Concurrency               int             `json:"concurrency"`
	TargetMessagesPerSecond   int             `json:"target_messages_per_second"`
	TransformerWorkIterations uint64          `json:"transformer_work_iterations"`
	SinkProcessDelayMillis    uint64          `json:"sink_process_delay_ms"`
	MaxRetryAttempts          int             `json:"max_retry_attempts"`
	RetryBackoffMillis        int             `json:"retry_backoff_ms"`
	FailureAction             string          `json:"failure_action,omitempty"`
	FailureTarget             string          `json:"failure_target,omitempty"`
	FailureAfterSeconds       int             `json:"failure_after_seconds,omitempty"`
	ProducerStartedAt         string          `json:"producer_started_at"`
	ProducerFinishedAt        string          `json:"producer_finished_at"`
	StreamAcks                []*pb.StreamAck `json:"stream_acks"`
	UnaryAcknowledgedRequests uint64          `json:"unary_acknowledged_requests"`
	RetryAttempts             uint64          `json:"retry_attempts"`
	StreamReconnects          uint64          `json:"stream_reconnects"`
	RecoveryEvents            int             `json:"recovery_events"`
	AvgRecoveryMs             float64         `json:"avg_recovery_ms"`
	MaxRecoveryMs             float64         `json:"max_recovery_ms"`
	SinkSummary               *pb.RunSummary  `json:"sink_summary"`
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
	diagnostics := &producerDiagnostics{}

	registeredAt := time.Now()
	_, err = adminClient.RegisterRun(ctx, &pb.RunConfig{
		RunId:                     cfg.runID,
		Profile:                   cfg.profile,
		ExpectedTotalMessages:     cfg.expectedTotalMessages,
		PayloadBytes:              uint64(payloadSource.NominalPayloadBytes()),
		Concurrency:               uint64(cfg.concurrency),
		TargetMessagesPerSecond:   uint64(cfg.targetMessagesPerSecond),
		TransformerWorkIterations: cfg.transformerWorkIterations,
		SinkProcessDelayMs:        cfg.sinkProcessDelayMillis,
		RegisteredAtUnixNano:      registeredAt.UnixNano(),
		TransportMode:             cfg.transportMode,
	})
	if err != nil {
		log.Fatalf("register run: %v", err)
	}

	var limiter *rate.Limiter
	if cfg.targetMessagesPerSecond > 0 {
		limiter = rate.NewLimiter(rate.Limit(cfg.targetMessagesPerSecond), maxInt(1, cfg.targetMessagesPerSecond))
	}

	startedAt := time.Now()
	acks, unaryAckCount, err := runTransport(ctx, transformerClient, cfg, limiter, payloadSource, diagnostics)
	if err != nil {
		log.Fatalf("run %s workload: %v", cfg.transportMode, err)
	}

	summary, err := waitForSummary(ctx, adminClient, cfg)
	if err != nil {
		log.Fatalf("wait for sink summary: %v", err)
	}

	retryAttempts, streamReconnects, recoveryEvents, avgRecoveryMs, maxRecoveryMs := diagnostics.snapshot()

	result := producerResult{
		RunID:                     cfg.runID,
		TransportMode:             cfg.transportMode,
		WorkloadSource:            cfg.workloadSource,
		WorkloadDescriptor:        payloadSource.Descriptor(),
		Profile:                   cfg.profile,
		ExpectedMessages:          cfg.expectedTotalMessages,
		PayloadBytes:              payloadSource.NominalPayloadBytes(),
		Concurrency:               cfg.concurrency,
		TargetMessagesPerSecond:   cfg.targetMessagesPerSecond,
		TransformerWorkIterations: cfg.transformerWorkIterations,
		SinkProcessDelayMillis:    cfg.sinkProcessDelayMillis,
		MaxRetryAttempts:          cfg.maxRetryAttempts,
		RetryBackoffMillis:        int(cfg.retryBackoff / time.Millisecond),
		FailureAction:             cfg.failureAction,
		FailureTarget:             cfg.failureTarget,
		FailureAfterSeconds:       cfg.failureAfterSeconds,
		ProducerStartedAt:         startedAt.UTC().Format(time.RFC3339Nano),
		ProducerFinishedAt:        time.Now().UTC().Format(time.RFC3339Nano),
		StreamAcks:                acks,
		UnaryAcknowledgedRequests: unaryAckCount,
		RetryAttempts:             retryAttempts,
		StreamReconnects:          streamReconnects,
		RecoveryEvents:            recoveryEvents,
		AvgRecoveryMs:             avgRecoveryMs,
		MaxRecoveryMs:             maxRecoveryMs,
		SinkSummary:               summary,
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
	maxRetryAttempts, err := config.Int("MAX_RETRY_ATTEMPTS", 0)
	if err != nil {
		return nil, err
	}
	retryBackoffMillis, err := config.Int("RETRY_BACKOFF_MS", 500)
	if err != nil {
		return nil, err
	}
	failureAfterSeconds, err := config.Int("FAILURE_AFTER_SECONDS", 0)
	if err != nil {
		return nil, err
	}

	return &producerConfig{
		runID:                     config.String("RUN_ID", fmt.Sprintf("grpc-stream-%d", time.Now().Unix())),
		transportMode:             config.String("TRANSPORT_MODE", "client-streaming"),
		workloadSource:            config.String("WORKLOAD_SOURCE", "synthetic"),
		transformerAddr:           config.String("TRANSFORMER_ADDR", "localhost:50051"),
		sinkAdminAddr:             config.String("SINK_ADMIN_ADDR", "localhost:50052"),
		resultDir:                 config.String("RESULT_DIR", "/results"),
		profile:                   config.String("PROFILE", "bulk"),
		expectedTotalMessages:     expectedTotalMessages,
		payloadBytes:              payloadBytes,
		datasetDir:                config.String("DATASET_DIR", "/datasets"),
		datasetFiles:              config.String("DATASET_FILES", ""),
		datasetRowsPerMessage:     datasetRowsPerMessage,
		datasetRepeatCount:        datasetRepeatCount,
		concurrency:               concurrency,
		targetMessagesPerSecond:   targetMessagesPerSecond,
		transformerWorkIterations: transformerWorkIterations,
		sinkProcessDelayMillis:    sinkProcessDelayMillis,
		maxRetryAttempts:          maxRetryAttempts,
		retryBackoff:              time.Duration(retryBackoffMillis) * time.Millisecond,
		failureAction:             config.String("FAILURE_ACTION", ""),
		failureTarget:             config.String("FAILURE_TARGET", ""),
		failureAfterSeconds:       failureAfterSeconds,
		pollInterval:              time.Duration(pollMillis) * time.Millisecond,
		maxSummaryWait:            time.Duration(maxWaitSeconds) * time.Second,
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

func runTransport(ctx context.Context, client pb.TransformerClient, cfg *producerConfig, limiter *rate.Limiter, payloadSource workload.Source, diagnostics *producerDiagnostics) ([]*pb.StreamAck, uint64, error) {
	switch cfg.transportMode {
	case "client-streaming":
		acks, err := sendBulkStreaming(ctx, client, cfg, limiter, payloadSource, diagnostics)
		return acks, 0, err
	case "unary":
		count, err := sendBulkUnary(ctx, client, cfg, limiter, payloadSource, diagnostics)
		return nil, count, err
	default:
		return nil, 0, fmt.Errorf("unsupported TRANSPORT_MODE %q", cfg.transportMode)
	}
}

func sendBulkStreaming(ctx context.Context, client pb.TransformerClient, cfg *producerConfig, limiter *rate.Limiter, payloadSource workload.Source, diagnostics *producerDiagnostics) ([]*pb.StreamAck, error) {
	ackChan := make(chan *pb.StreamAck, cfg.concurrency)
	errChan := make(chan error, cfg.concurrency)
	var wg sync.WaitGroup

	for worker := 0; worker < cfg.concurrency; worker++ {
		worker := worker
		workerSequences := make([]uint64, 0, int((cfg.expectedTotalMessages+uint64(cfg.concurrency)-1)/uint64(cfg.concurrency)))
		for sequence := uint64(worker + 1); sequence <= cfg.expectedTotalMessages; sequence += uint64(cfg.concurrency) {
			workerSequences = append(workerSequences, sequence)
		}
		wg.Add(1)
		go func() {
			defer wg.Done()

			stream, err := openStream(ctx, client, cfg, diagnostics, false, time.Time{})
			if err != nil {
				errChan <- fmt.Errorf("worker %d open stream: %w", worker, err)
				return
			}

			nextIndex := 0
			for {
				for nextIndex < len(workerSequences) {
					sequence := workerSequences[nextIndex]
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
						if !isRetryableError(err) || cfg.maxRetryAttempts <= 0 {
							errChan <- fmt.Errorf("worker %d send sequence %d: %w", worker, sequence, err)
							return
						}
						diagnostics.recordRetry()
						recoveryStartedAt := time.Now()
						stream, err = openStream(ctx, client, cfg, diagnostics, true, recoveryStartedAt)
						if err != nil {
							errChan <- fmt.Errorf("worker %d recover stream after sequence %d failure: %w", worker, sequence, err)
							return
						}
						nextIndex = 0
						continue
					}
					nextIndex++
				}

				ack, err := stream.CloseAndRecv()
				if err == nil {
					ackChan <- ack
					return
				}
				if !isRetryableError(err) || cfg.maxRetryAttempts <= 0 {
					errChan <- fmt.Errorf("worker %d close stream: %w", worker, err)
					return
				}
				diagnostics.recordRetry()
				recoveryStartedAt := time.Now()
				stream, err = openStream(ctx, client, cfg, diagnostics, true, recoveryStartedAt)
				if err != nil {
					errChan <- fmt.Errorf("worker %d recover stream after close failure: %w", worker, err)
					return
				}
				nextIndex = 0
			}
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

func sendBulkUnary(ctx context.Context, client pb.TransformerClient, cfg *producerConfig, limiter *rate.Limiter, payloadSource workload.Source, diagnostics *producerDiagnostics) (uint64, error) {
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
				chunk := &pb.DataChunk{
					RunId:             cfg.runID,
					Sequence:          sequence,
					ProducerWorker:    uint64(worker),
					CreatedAtUnixNano: time.Now().UnixNano(),
					Payload:           payloadSource.Payload(sequence),
				}
				attempt := 0
				recoveryStartedAt := time.Time{}
				for {
					_, err := client.PushUnary(ctx, chunk)
					if err == nil {
						if !recoveryStartedAt.IsZero() {
							diagnostics.recordRecovery(time.Since(recoveryStartedAt))
						}
						break
					}
					if !canRetry(err, attempt, cfg.maxRetryAttempts) {
						errChan <- fmt.Errorf("worker %d unary send sequence %d: %w", worker, sequence, err)
						return
					}
					if recoveryStartedAt.IsZero() {
						recoveryStartedAt = time.Now()
					}
					diagnostics.recordRetry()
					attempt++
					if err := sleepWithContext(ctx, cfg.retryBackoff); err != nil {
						errChan <- fmt.Errorf("worker %d unary retry wait for sequence %d: %w", worker, sequence, err)
						return
					}
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

func openStream(ctx context.Context, client pb.TransformerClient, cfg *producerConfig, diagnostics *producerDiagnostics, reconnect bool, recoveryStartedAt time.Time) (pb.Transformer_PushClient, error) {
	attempt := 0
	for {
		stream, err := client.Push(ctx)
		if err == nil {
			if reconnect {
				diagnostics.recordStreamReconnect()
				if !recoveryStartedAt.IsZero() {
					diagnostics.recordRecovery(time.Since(recoveryStartedAt))
				}
			}
			return stream, nil
		}
		if !canRetry(err, attempt, cfg.maxRetryAttempts) {
			return nil, err
		}
		diagnostics.recordRetry()
		attempt++
		if err := sleepWithContext(ctx, cfg.retryBackoff); err != nil {
			return nil, err
		}
	}
}

func canRetry(err error, attempt int, maxRetryAttempts int) bool {
	if maxRetryAttempts <= 0 || !isRetryableError(err) {
		return false
	}
	return attempt < maxRetryAttempts
}

func isRetryableError(err error) bool {
	if err == nil {
		return false
	}
	if errors.Is(err, context.Canceled) || errors.Is(err, context.DeadlineExceeded) {
		return false
	}
	if errors.Is(err, io.EOF) {
		return true
	}
	statusErr, ok := status.FromError(err)
	if !ok {
		return true
	}
	switch statusErr.Code() {
	case codes.InvalidArgument, codes.FailedPrecondition, codes.PermissionDenied, codes.Unauthenticated, codes.Unimplemented:
		return false
	default:
		return true
	}
}

func sleepWithContext(ctx context.Context, duration time.Duration) error {
	if duration <= 0 {
		return nil
	}
	timer := time.NewTimer(duration)
	defer timer.Stop()
	select {
	case <-ctx.Done():
		return ctx.Err()
	case <-timer.C:
		return nil
	}
}

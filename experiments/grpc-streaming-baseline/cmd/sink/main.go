package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"math"
	"net"
	"os"
	"os/signal"
	"sort"
	"sync"
	"syscall"
	"time"

	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/app"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/config"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/metrics"
	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"github.com/prometheus/client_golang/prometheus"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type sinkMetrics struct {
	messages           prometheus.Counter
	bytes              prometheus.Counter
	duplicates         prometheus.Counter
	orderingViolations prometheus.Counter
	activeRuns         prometheus.Gauge
	latencyMillis      prometheus.Histogram
	streams            prometheus.Counter
	unary              prometheus.Counter
}

type runState struct {
	config             *pb.RunConfig
	registeredAt       time.Time
	startedAt          time.Time
	finishedAt         time.Time
	completed          bool
	messagesReceived   uint64
	bytesReceived      uint64
	duplicates         uint64
	orderingViolations uint64
	latenciesMillis    []float64
	seenSequences      map[uint64]struct{}
	lastByWorker       map[uint64]uint64
	summary            *pb.RunSummary
}

type sinkServer struct {
	pb.UnimplementedSinkServer
	pb.UnimplementedExperimentAdminServer

	mu         sync.Mutex
	runs       map[string]*runState
	metrics    sinkMetrics
	resultDir  string
	processDelay time.Duration
}

func main() {
	listenAddr := config.String("LISTEN_ADDR", ":50052")
	metricsAddr := config.String("METRICS_ADDR", ":9102")
	resultDir := config.String("RESULT_DIR", "/results")
	processDelay, err := config.DurationMillis("SINK_PROCESS_DELAY_MS", 0)
	if err != nil {
		log.Fatalf("invalid SINK_PROCESS_DELAY_MS: %v", err)
	}

	registry := prometheus.NewRegistry()
	serverMetrics := sinkMetrics{
		messages: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_sink_messages_received_total",
			Help: "Total number of messages received by the sink.",
		}),
		bytes: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_sink_bytes_received_total",
			Help: "Total number of payload bytes received by the sink.",
		}),
		duplicates: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_sink_duplicate_messages_total",
			Help: "Total duplicate messages detected by the sink.",
		}),
		orderingViolations: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_sink_ordering_violations_total",
			Help: "Total per-flow ordering violations detected by the sink.",
		}),
		activeRuns: prometheus.NewGauge(prometheus.GaugeOpts{
			Name: "experiment_sink_active_runs",
			Help: "Number of runs currently known to the sink.",
		}),
		latencyMillis: prometheus.NewHistogram(prometheus.HistogramOpts{
			Name:    "experiment_sink_end_to_end_latency_milliseconds",
			Help:    "End-to-end latency observed at the sink in milliseconds.",
			Buckets: []float64{1, 2, 5, 10, 20, 50, 100, 250, 500, 1000, 2000, 5000},
		}),
		streams: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_sink_streams_total",
			Help: "Number of client streams received by the sink.",
		}),
		unary: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_sink_unary_requests_total",
			Help: "Number of unary requests received by the sink.",
		}),
	}
	registry.MustRegister(
		serverMetrics.messages,
		serverMetrics.bytes,
		serverMetrics.duplicates,
		serverMetrics.orderingViolations,
		serverMetrics.activeRuns,
		serverMetrics.latencyMillis,
		serverMetrics.streams,
		serverMetrics.unary,
	)

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer cancel()

	go func() {
		if err := metrics.Serve(ctx, metricsAddr, registry); err != nil {
			log.Fatalf("metrics server: %v", err)
		}
	}()

	listener, err := net.Listen("tcp", listenAddr)
	if err != nil {
		log.Fatalf("listen %s: %v", listenAddr, err)
	}

	grpcServer := grpc.NewServer()
	server := &sinkServer{
		runs:        make(map[string]*runState),
		metrics:     serverMetrics,
		resultDir:   resultDir,
		processDelay: processDelay,
	}
	pb.RegisterSinkServer(grpcServer, server)
	pb.RegisterExperimentAdminServer(grpcServer, server)

	go func() {
		<-ctx.Done()
		grpcServer.GracefulStop()
	}()

	log.Printf("sink listening on %s", listenAddr)
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("serve gRPC: %v", err)
	}
}

func (s *sinkServer) RegisterRun(_ context.Context, in *pb.RunConfig) (*pb.RegisterRunResponse, error) {
	if in.GetRunId() == "" {
		return nil, status.Error(codes.InvalidArgument, "run_id is required")
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	if _, exists := s.runs[in.GetRunId()]; exists {
		return &pb.RegisterRunResponse{Accepted: true}, nil
	}

	registeredAt := time.Unix(0, in.GetRegisteredAtUnixNano())
	if in.GetRegisteredAtUnixNano() == 0 {
		registeredAt = time.Now()
	}

	s.runs[in.GetRunId()] = &runState{
		config:        in,
		registeredAt:  registeredAt,
		latenciesMillis: make([]float64, 0, in.GetExpectedTotalMessages()),
		seenSequences: make(map[uint64]struct{}),
		lastByWorker:  make(map[uint64]uint64),
	}
	s.metrics.activeRuns.Inc()
	return &pb.RegisterRunResponse{Accepted: true}, nil
}

func (s *sinkServer) GetRunSummary(_ context.Context, in *pb.RunQuery) (*pb.RunSummary, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	state, exists := s.runs[in.GetRunId()]
	if !exists {
		return nil, status.Error(codes.NotFound, "run not found")
	}
	if state.summary != nil {
		return state.summary, nil
	}

	summary := &pb.RunSummary{
		RunId:              in.GetRunId(),
		Stage:              "sink",
		Completed:          state.completed,
		MessagesReceived:   state.messagesReceived,
		BytesReceived:      state.bytesReceived,
		Duplicates:         state.duplicates,
		OrderingViolations: state.orderingViolations,
		TransportMode:      state.config.GetTransportMode(),
	}
	if !state.startedAt.IsZero() {
		summary.StartedAtUnixNano = state.startedAt.UnixNano()
	}
	if !state.finishedAt.IsZero() {
		summary.FinishedAtUnixNano = state.finishedAt.UnixNano()
	}
	return summary, nil
}

func (s *sinkServer) Push(stream pb.Sink_PushServer) error {
	s.metrics.streams.Inc()
	var runID string
	var streamMessages uint64
	var streamBytes uint64

	for {
		chunk, err := stream.Recv()
		if err == io.EOF {
			return stream.SendAndClose(&pb.StreamAck{
				RunId:              runID,
				Stage:              "sink",
				StreamMessages:     streamMessages,
				StreamBytes:        streamBytes,
				FinishedAtUnixNano: time.Now().UnixNano(),
			})
		}
		if err != nil {
			return err
		}
		if chunk.GetRunId() == "" {
			return status.Error(codes.InvalidArgument, "run_id is required in DataChunk")
		}
		runID = chunk.GetRunId()
		streamMessages++
		streamBytes += uint64(len(chunk.GetPayload()))

		if err := s.ingest(chunk); err != nil {
			return err
		}
	}
}

func (s *sinkServer) PushUnary(_ context.Context, chunk *pb.DataChunk) (*pb.UnaryAck, error) {
	if chunk.GetRunId() == "" {
		return nil, status.Error(codes.InvalidArgument, "run_id is required in DataChunk")
	}
	s.metrics.unary.Inc()
	if err := s.ingest(chunk); err != nil {
		return nil, err
	}
	return &pb.UnaryAck{
		RunId:              chunk.GetRunId(),
		Stage:              "sink",
		Sequence:           chunk.GetSequence(),
		FinishedAtUnixNano: time.Now().UnixNano(),
	}, nil
}

func (s *sinkServer) ingest(chunk *pb.DataChunk) error {
	now := time.Now()

	s.mu.Lock()
	state, exists := s.runs[chunk.GetRunId()]
	if !exists {
		s.mu.Unlock()
		return status.Errorf(codes.FailedPrecondition, "run %s has not been registered", chunk.GetRunId())
	}
	if state.startedAt.IsZero() {
		state.startedAt = now
	}
	if _, duplicate := state.seenSequences[chunk.GetSequence()]; duplicate {
		state.duplicates++
		s.metrics.duplicates.Inc()
	} else {
		state.seenSequences[chunk.GetSequence()] = struct{}{}
	}
	if last, exists := state.lastByWorker[chunk.GetProducerWorker()]; exists && chunk.GetSequence() <= last {
		state.orderingViolations++
		s.metrics.orderingViolations.Inc()
	}
	state.lastByWorker[chunk.GetProducerWorker()] = chunk.GetSequence()
	latencyMillis := float64(now.UnixNano()-chunk.GetCreatedAtUnixNano()) / float64(time.Millisecond)
	state.latenciesMillis = append(state.latenciesMillis, latencyMillis)
	state.messagesReceived++
	state.bytesReceived += uint64(len(chunk.GetPayload()))
	s.metrics.messages.Inc()
	s.metrics.bytes.Add(float64(len(chunk.GetPayload())))
	s.metrics.latencyMillis.Observe(latencyMillis)

	completed := !state.completed && state.config.GetExpectedTotalMessages() > 0 && state.messagesReceived >= state.config.GetExpectedTotalMessages()
	if completed {
		state.completed = true
		state.finishedAt = now
		state.summary = buildSummary(chunk.GetRunId(), state)
		if err := app.WriteJSON(s.resultDir, fmt.Sprintf("%s-sink-summary.json", chunk.GetRunId()), state.summary); err != nil {
			log.Printf("write sink summary: %v", err)
		}
	}
	s.mu.Unlock()

	if s.processDelay > 0 {
		time.Sleep(s.processDelay)
	}
	return nil
}

func buildSummary(runID string, state *runState) *pb.RunSummary {
	latencies := append([]float64(nil), state.latenciesMillis...)
	sort.Float64s(latencies)
	duration := state.finishedAt.Sub(state.registeredAt)
	if duration <= 0 {
		duration = state.finishedAt.Sub(state.startedAt)
	}
	seconds := duration.Seconds()
	if seconds <= 0 {
		seconds = 1e-9
	}
	return &pb.RunSummary{
		RunId:                        runID,
		Stage:                        "sink",
		Completed:                    true,
		MessagesReceived:             state.messagesReceived,
		BytesReceived:                state.bytesReceived,
		Duplicates:                   state.duplicates,
		OrderingViolations:           state.orderingViolations,
		DurationSeconds:              seconds,
		ThroughputMessagesPerSecond:  float64(state.messagesReceived) / seconds,
		ThroughputMegabytesPerSecond: (float64(state.bytesReceived) / (1024.0 * 1024.0)) / seconds,
		P50LatencyMs:                 percentile(latencies, 0.50),
		P95LatencyMs:                 percentile(latencies, 0.95),
		P99LatencyMs:                 percentile(latencies, 0.99),
		MaxLatencyMs:                 maxValue(latencies),
		StartedAtUnixNano:            state.startedAt.UnixNano(),
		FinishedAtUnixNano:           state.finishedAt.UnixNano(),
		TransportMode:                state.config.GetTransportMode(),
	}
}

func percentile(sortedValues []float64, p float64) float64 {
	if len(sortedValues) == 0 {
		return 0
	}
	index := int(math.Ceil(p*float64(len(sortedValues)))) - 1
	if index < 0 {
		index = 0
	}
	if index >= len(sortedValues) {
		index = len(sortedValues) - 1
	}
	return sortedValues[index]
}

func maxValue(values []float64) float64 {
	if len(values) == 0 {
		return 0
	}
	max := values[0]
	for _, value := range values[1:] {
		if value > max {
			max = value
		}
	}
	return max
}


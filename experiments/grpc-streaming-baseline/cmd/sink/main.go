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
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/transport"
	"github.com/prometheus/client_golang/prometheus"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type sinkConfig struct {
	listenAddr    string
	metricsAddr   string
	resultDir     string
	processDelay  time.Duration
	transportMode string
	rabbitMQ      transport.RabbitMQConfig
}

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
	consumerCancel     context.CancelFunc
	registeredAt       time.Time
	startedAt          time.Time
	finishedAt         time.Time
	lastArrivalAt      time.Time
	completed          bool
	messagesReceived   uint64
	bytesReceived      uint64
	duplicates         uint64
	orderingViolations uint64
	latenciesMillis    []float64
	interArrivalMillis []float64
	seenSequences      map[uint64]struct{}
	lastByWorker       map[uint64]uint64
	summary            *pb.RunSummary
}

type sinkServer struct {
	pb.UnimplementedSinkServer
	pb.UnimplementedExperimentAdminServer

	ctx          context.Context
	mu           sync.Mutex
	runs         map[string]*runState
	metrics      sinkMetrics
	resultDir    string
	rabbitMQ     transport.RabbitMQConfig
	processDelay time.Duration
}

func main() {
	cfg, err := loadConfig()
	if err != nil {
		log.Fatalf("load config: %v", err)
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
		if err := metrics.Serve(ctx, cfg.metricsAddr, registry); err != nil {
			log.Fatalf("metrics server: %v", err)
		}
	}()

	listener, err := net.Listen("tcp", cfg.listenAddr)
	if err != nil {
		log.Fatalf("listen %s: %v", cfg.listenAddr, err)
	}

	grpcServer := grpc.NewServer()
	server := &sinkServer{
		ctx:          ctx,
		runs:         make(map[string]*runState),
		metrics:      serverMetrics,
		resultDir:    cfg.resultDir,
		rabbitMQ:     cfg.rabbitMQ,
		processDelay: cfg.processDelay,
	}
	pb.RegisterSinkServer(grpcServer, server)
	pb.RegisterExperimentAdminServer(grpcServer, server)

	go func() {
		<-ctx.Done()
		grpcServer.GracefulStop()
	}()

	log.Printf("sink listening on %s via %s", cfg.listenAddr, cfg.transportMode)
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("serve gRPC: %v", err)
	}
}

func loadConfig() (*sinkConfig, error) {
	processDelay, err := config.DurationMillis("SINK_PROCESS_DELAY_MS", 0)
	if err != nil {
		return nil, fmt.Errorf("invalid SINK_PROCESS_DELAY_MS: %w", err)
	}
	transportMode := config.String("TRANSPORT_MODE", transport.ModeClientStreaming)
	if !transport.IsSupportedMode(transportMode) {
		return nil, fmt.Errorf("unsupported TRANSPORT_MODE %q", transportMode)
	}
	rabbitMQConfig, err := transport.LoadRabbitMQConfig()
	if err != nil {
		return nil, err
	}

	return &sinkConfig{
		listenAddr:    config.String("LISTEN_ADDR", ":50052"),
		metricsAddr:   config.String("METRICS_ADDR", ":9102"),
		resultDir:     config.String("RESULT_DIR", "/results"),
		processDelay:  processDelay,
		transportMode: transportMode,
		rabbitMQ:      rabbitMQConfig,
	}, nil
}

func (s *sinkServer) RegisterRun(_ context.Context, in *pb.RunConfig) (*pb.RegisterRunResponse, error) {
	if in.GetRunId() == "" {
		return nil, status.Error(codes.InvalidArgument, "run_id is required")
	}

	var runCtx context.Context
	var startConsumers bool

	s.mu.Lock()

	if _, exists := s.runs[in.GetRunId()]; exists {
		s.mu.Unlock()
		return &pb.RegisterRunResponse{Accepted: true}, nil
	}

	registeredAt := time.Unix(0, in.GetRegisteredAtUnixNano())
	if in.GetRegisteredAtUnixNano() == 0 {
		registeredAt = time.Now()
	}

	state := &runState{
		config:             in,
		registeredAt:       registeredAt,
		latenciesMillis:    make([]float64, 0, in.GetExpectedTotalMessages()),
		interArrivalMillis: make([]float64, 0, in.GetExpectedTotalMessages()),
		seenSequences:      make(map[uint64]struct{}),
		lastByWorker:       make(map[uint64]uint64),
	}
	if in.GetTransportMode() == transport.ModeRabbitMQStreams {
		runCtx, state.consumerCancel = context.WithCancel(s.ctx)
		startConsumers = true
	}
	s.runs[in.GetRunId()] = state
	s.metrics.activeRuns.Inc()
	s.mu.Unlock()

	if startConsumers {
		s.startRabbitMQRunConsumers(runCtx, in)
	}
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
	if !state.lastArrivalAt.IsZero() {
		state.interArrivalMillis = append(state.interArrivalMillis, float64(now.Sub(state.lastArrivalAt))/float64(time.Millisecond))
	}
	state.lastArrivalAt = now
	if _, duplicate := state.seenSequences[chunk.GetSequence()]; duplicate {
		state.duplicates++
		s.metrics.duplicates.Inc()
		s.mu.Unlock()

		if s.processDelay > 0 {
			time.Sleep(s.processDelay)
		}
		return nil
	}
	state.seenSequences[chunk.GetSequence()] = struct{}{}
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
	var cancelConsumers context.CancelFunc
	if completed {
		state.completed = true
		state.finishedAt = now
		state.summary = buildSummary(chunk.GetRunId(), state)
		cancelConsumers = state.consumerCancel
		state.consumerCancel = nil
		if err := app.WriteJSON(s.resultDir, fmt.Sprintf("%s-sink-summary.json", chunk.GetRunId()), state.summary); err != nil {
			log.Printf("write sink summary: %v", err)
		}
	}
	s.mu.Unlock()

	if cancelConsumers != nil {
		cancelConsumers()
	}

	if s.processDelay > 0 {
		time.Sleep(s.processDelay)
	}
	return nil
}

func buildSummary(runID string, state *runState) *pb.RunSummary {
	latencies := append([]float64(nil), state.latenciesMillis...)
	sort.Float64s(latencies)
	interArrivals := append([]float64(nil), state.interArrivalMillis...)
	sortedInterArrivals := append([]float64(nil), interArrivals...)
	sort.Float64s(sortedInterArrivals)
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
		MeanInterArrivalMs:           meanValue(interArrivals),
		P95InterArrivalMs:            percentile(sortedInterArrivals, 0.95),
		InterArrivalJitterMs:         stddevValue(interArrivals),
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

func meanValue(values []float64) float64 {
	if len(values) == 0 {
		return 0
	}
	var total float64
	for _, value := range values {
		total += value
	}
	return total / float64(len(values))
}

func stddevValue(values []float64) float64 {
	if len(values) <= 1 {
		return 0
	}
	mean := meanValue(values)
	var total float64
	for _, value := range values {
		delta := value - mean
		total += delta * delta
	}
	return math.Sqrt(total / float64(len(values)))
}

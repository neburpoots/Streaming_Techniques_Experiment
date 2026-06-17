package main

import (
	"context"
	"crypto/sha256"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/config"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/metrics"
	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/transport"
	"github.com/prometheus/client_golang/prometheus"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type transformerConfig struct {
	listenAddr    string
	metricsAddr   string
	sinkAddr      string
	runID         string
	transportMode string
	workIters     int
	concurrency   int
	grpcMaxBytes  int
	rabbitMQ      transport.RabbitMQConfig
	nats          transport.NATSConfig
	kafka         transport.KafkaConfig
}

type transformerServer struct {
	pb.UnimplementedTransformerServer
	sinkClient pb.SinkClient
	metrics    transformerMetrics
	workIters  int
}

type transformerMetrics struct {
	messages  prometheus.Counter
	bytes     prometheus.Counter
	streams   prometheus.Counter
	unary     prometheus.Counter
	workNanos prometheus.Histogram
}

func main() {
	cfg, err := loadConfig()
	if err != nil {
		log.Fatalf("load config: %v", err)
	}

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer cancel()

	registry := prometheus.NewRegistry()
	serverMetrics := transformerMetrics{
		messages: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_transformer_messages_forwarded_total",
			Help: "Total number of messages forwarded by the transformer.",
		}),
		bytes: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_transformer_bytes_forwarded_total",
			Help: "Total number of payload bytes forwarded by the transformer.",
		}),
		streams: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_transformer_streams_total",
			Help: "Total number of producer streams handled by the transformer.",
		}),
		unary: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "experiment_transformer_unary_requests_total",
			Help: "Total number of unary requests handled by the transformer.",
		}),
		workNanos: prometheus.NewHistogram(prometheus.HistogramOpts{
			Name:    "experiment_transformer_work_duration_nanoseconds",
			Help:    "Synthetic transformer work duration in nanoseconds.",
			Buckets: []float64{1e3, 5e3, 1e4, 5e4, 1e5, 5e5, 1e6, 5e6, 1e7},
		}),
	}
	registry.MustRegister(serverMetrics.messages, serverMetrics.bytes, serverMetrics.streams, serverMetrics.unary, serverMetrics.workNanos)

	go func() {
		if err := metrics.Serve(ctx, cfg.metricsAddr, registry); err != nil {
			log.Fatalf("metrics server: %v", err)
		}
	}()

	conn, err := grpc.NewClient(
		cfg.sinkAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithDefaultCallOptions(
			grpc.MaxCallSendMsgSize(cfg.grpcMaxBytes),
			grpc.MaxCallRecvMsgSize(cfg.grpcMaxBytes),
		),
	)
	if err != nil {
		log.Fatalf("connect sink %s: %v", cfg.sinkAddr, err)
	}
	defer conn.Close()

	listener, err := net.Listen("tcp", cfg.listenAddr)
	if err != nil {
		log.Fatalf("listen %s: %v", cfg.listenAddr, err)
	}

	grpcServer := grpc.NewServer(
		grpc.MaxRecvMsgSize(cfg.grpcMaxBytes),
		grpc.MaxSendMsgSize(cfg.grpcMaxBytes),
	)
	server := &transformerServer{
		sinkClient: pb.NewSinkClient(conn),
		metrics:    serverMetrics,
		workIters:  cfg.workIters,
	}
	pb.RegisterTransformerServer(grpcServer, server)

	if cfg.transportMode == transport.ModeRabbitMQStreams {
		startRabbitMQBridge(ctx, server, cfg)
	}
	if cfg.transportMode == transport.ModeNATSJetStream {
		startNATSBridge(ctx, server, cfg)
	}
	if cfg.transportMode == transport.ModeKafka {
		startKafkaBridge(ctx, server, cfg)
	}

	go func() {
		<-ctx.Done()
		grpcServer.GracefulStop()
	}()

	log.Printf("transformer listening on %s, forwarding to %s via %s", cfg.listenAddr, cfg.sinkAddr, cfg.transportMode)
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("serve gRPC: %v", err)
	}
}

func loadConfig() (*transformerConfig, error) {
	workIters, err := config.Int("TRANSFORMER_WORK_ITERATIONS", 0)
	if err != nil {
		return nil, fmt.Errorf("invalid TRANSFORMER_WORK_ITERATIONS: %w", err)
	}
	concurrency, err := config.Int("CONCURRENCY", 1)
	if err != nil {
		return nil, fmt.Errorf("invalid CONCURRENCY: %w", err)
	}
	if concurrency <= 0 {
		return nil, fmt.Errorf("CONCURRENCY must be positive")
	}
	grpcMaxBytes, err := config.Int("GRPC_MAX_MESSAGE_BYTES", 128*1024*1024)
	if err != nil {
		return nil, fmt.Errorf("invalid GRPC_MAX_MESSAGE_BYTES: %w", err)
	}
	if grpcMaxBytes <= 0 {
		return nil, fmt.Errorf("GRPC_MAX_MESSAGE_BYTES must be positive")
	}
	transportMode := config.String("TRANSPORT_MODE", transport.ModeClientStreaming)
	if !transport.IsSupportedMode(transportMode) {
		return nil, fmt.Errorf("unsupported TRANSPORT_MODE %q", transportMode)
	}
	rabbitMQConfig, err := transport.LoadRabbitMQConfig()
	if err != nil {
		return nil, err
	}
	natsConfig := transport.LoadNATSConfig()
	kafkaConfig := transport.LoadKafkaConfig()

	return &transformerConfig{
		listenAddr:    config.String("LISTEN_ADDR", ":50051"),
		metricsAddr:   config.String("METRICS_ADDR", ":9101"),
		sinkAddr:      config.String("SINK_ADDR", "sink:50052"),
		runID:         config.String("RUN_ID", "grpc-stream-local"),
		transportMode: transportMode,
		workIters:     workIters,
		concurrency:   concurrency,
		grpcMaxBytes:  grpcMaxBytes,
		rabbitMQ:      rabbitMQConfig,
		nats:          natsConfig,
		kafka:         kafkaConfig,
	}, nil
}

func (s *transformerServer) Push(stream pb.Transformer_PushServer) error {
	s.metrics.streams.Inc()
	forward, err := s.sinkClient.Push(stream.Context())
	if err != nil {
		return err
	}

	var messages uint64
	var bytes uint64

	for {
		chunk, err := stream.Recv()
		if err == io.EOF {
			ack, closeErr := forward.CloseAndRecv()
			if closeErr != nil {
				return closeErr
			}
			return stream.SendAndClose(&pb.StreamAck{
				RunId:              ack.GetRunId(),
				Stage:              "transformer",
				StreamMessages:     messages,
				StreamBytes:        bytes,
				FinishedAtUnixNano: time.Now().UnixNano(),
			})
		}
		if err != nil {
			return err
		}

		messages++
		bytes += uint64(len(chunk.GetPayload()))
		s.metrics.messages.Inc()
		s.metrics.bytes.Add(float64(len(chunk.GetPayload())))

		if s.workIters > 0 {
			start := time.Now()
			payload := chunk.GetPayload()
			for i := 0; i < s.workIters; i++ {
				digest := sha256.Sum256(payload)
				payload = digest[:]
			}
			s.metrics.workNanos.Observe(float64(time.Since(start).Nanoseconds()))
		}

		if err := forward.Send(chunk); err != nil {
			return err
		}
	}
}

func (s *transformerServer) PushUnary(ctx context.Context, chunk *pb.DataChunk) (*pb.UnaryAck, error) {
	if chunk == nil {
		return nil, nil
	}
	s.metrics.unary.Inc()
	s.metrics.messages.Inc()
	s.metrics.bytes.Add(float64(len(chunk.GetPayload())))
	s.applyWork(chunk.GetPayload())
	ack, err := s.sinkClient.PushUnary(ctx, chunk)
	if err != nil {
		return nil, err
	}
	return &pb.UnaryAck{
		RunId:              ack.GetRunId(),
		Stage:              "transformer",
		Sequence:           chunk.GetSequence(),
		FinishedAtUnixNano: time.Now().UnixNano(),
	}, nil
}

func (s *transformerServer) PushUnaryBatch(ctx context.Context, batch *pb.DataBatch) (*pb.UnaryBatchAck, error) {
	if batch == nil || len(batch.GetChunks()) == 0 {
		return &pb.UnaryBatchAck{Stage: "transformer"}, nil
	}
	s.metrics.unary.Inc()
	for _, chunk := range batch.GetChunks() {
		if chunk == nil {
			continue
		}
		s.metrics.messages.Inc()
		s.metrics.bytes.Add(float64(len(chunk.GetPayload())))
		s.applyWork(chunk.GetPayload())
	}
	ack, err := s.sinkClient.PushUnaryBatch(ctx, batch)
	if err != nil {
		return nil, err
	}
	return &pb.UnaryBatchAck{
		RunId:              ack.GetRunId(),
		Stage:              "transformer",
		Messages:           ack.GetMessages(),
		FinishedAtUnixNano: time.Now().UnixNano(),
	}, nil
}

func (s *transformerServer) applyWork(payload []byte) {
	if s.workIters <= 0 {
		return
	}
	start := time.Now()
	buffer := payload
	for i := 0; i < s.workIters; i++ {
		digest := sha256.Sum256(buffer)
		buffer = digest[:]
	}
	s.metrics.workNanos.Observe(float64(time.Since(start).Nanoseconds()))
}

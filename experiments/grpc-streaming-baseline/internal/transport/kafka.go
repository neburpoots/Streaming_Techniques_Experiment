package transport

import (
	"context"
	"errors"
	"fmt"
	"net"
	"strconv"
	"strings"
	"sync"
	"time"

	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"github.com/segmentio/kafka-go"
	"google.golang.org/protobuf/proto"
)

type KafkaPublisher struct {
	writer        *kafka.Writer
	topic         string
	flushInterval time.Duration
	maxBatchSize  int
	maxBatchBytes int
	keyMode       string
	closeCh       chan struct{}
	flushDone     chan struct{}
	mu            sync.Mutex
	pending       []kafka.Message
	pendingBytes  int
	lastFlushAt   time.Time
}

type KafkaConsumer struct {
	reader *kafka.Reader
}

type KafkaDelivery struct {
	reader  *kafka.Reader
	message kafka.Message
}

const (
	kafkaFlushTimeout   = 5 * time.Second
	kafkaCommitTimeout  = 5 * time.Second
	kafkaWriterAttempts = 10
	kafkaTopicReadyWait = 30 * time.Second
)

func NewKafkaPublisher(cfg KafkaConfig, topic string) (*KafkaPublisher, error) {
	if err := ensureKafkaTopic(cfg, topic); err != nil {
		return nil, err
	}
	writer := &kafka.Writer{
		Addr:                   kafka.TCP(cfg.Brokers...),
		Topic:                  topic,
		Balancer:               kafkaBalancer(cfg.KeyMode),
		RequiredAcks:           kafkaRequiredAcks(cfg.RequiredAcks),
		BatchSize:              cfg.BatchSize,
		BatchBytes:             int64(cfg.BatchBytes),
		BatchTimeout:           cfg.BatchTimeout,
		Compression:            kafkaCompression(cfg.Compression),
		MaxAttempts:            kafkaWriterAttempts,
		AllowAutoTopicCreation: true,
	}
	publisher := &KafkaPublisher{
		writer:        writer,
		topic:         topic,
		flushInterval: cfg.BatchTimeout,
		maxBatchSize:  cfg.BatchSize,
		maxBatchBytes: cfg.BatchBytes,
		keyMode:       cfg.KeyMode,
		closeCh:       make(chan struct{}),
		flushDone:     make(chan struct{}),
		pending:       make([]kafka.Message, 0, cfg.QueueCapacity),
	}
	publisher.startPeriodicFlush()
	return publisher, nil
}

func (p *KafkaPublisher) startPeriodicFlush() {
	go func() {
		ticker := time.NewTicker(p.flushInterval)
		defer func() {
			ticker.Stop()
			close(p.flushDone)
		}()

		for {
			select {
			case <-ticker.C:
				ctx, cancel := context.WithTimeout(context.Background(), kafkaFlushTimeout)
				_ = p.flush(ctx)
				cancel()
			case <-p.closeCh:
				return
			}
		}
	}()
}

func NewKafkaConsumer(cfg KafkaConfig, topic string, consumerGroup string) (*KafkaConsumer, error) {
	if err := ensureKafkaTopic(cfg, topic); err != nil {
		return nil, err
	}
	if strings.TrimSpace(consumerGroup) == "" {
		return nil, errors.New("kafka consumer group is empty")
	}
	reader := kafka.NewReader(kafka.ReaderConfig{
		Brokers:        cfg.Brokers,
		Topic:          topic,
		GroupID:        consumerGroup,
		CommitInterval: cfg.CommitInterval,
		QueueCapacity:  cfg.QueueCapacity,
		MinBytes:       cfg.ReadMinBytes,
		MaxBytes:       cfg.ReadMaxBytes,
		MaxWait:        cfg.ReadMaxWait,
		StartOffset:    kafka.FirstOffset,
	})
	return &KafkaConsumer{reader: reader}, nil
}

func (p *KafkaPublisher) Close() error {
	if p == nil || p.writer == nil {
		return nil
	}
	close(p.closeCh)
	<-p.flushDone
	if err := p.flush(context.Background()); err != nil {
		return err
	}
	return p.writer.Close()
}

func (c *KafkaConsumer) ReceiveChunk(ctx context.Context) (*pb.DataChunk, *KafkaDelivery, error) {
	if c == nil || c.reader == nil {
		return nil, nil, errors.New("kafka consumer is not initialized")
	}
	msg, err := c.reader.FetchMessage(ctx)
	if err != nil {
		return nil, nil, err
	}
	chunk := &pb.DataChunk{}
	if err := proto.Unmarshal(msg.Value, chunk); err != nil {
		return nil, nil, fmt.Errorf("unmarshal kafka delivery from topic %q offset %d: %w", msg.Topic, msg.Offset, err)
	}
	return chunk, &KafkaDelivery{reader: c.reader, message: msg}, nil
}

func (c *KafkaConsumer) Close() error {
	if c == nil || c.reader == nil {
		return nil
	}
	return c.reader.Close()
}

func (d *KafkaDelivery) Commit() error {
	if d == nil || d.reader == nil {
		return nil
	}
	ctx, cancel := context.WithTimeout(context.Background(), kafkaCommitTimeout)
	defer cancel()
	return d.reader.CommitMessages(ctx, d.message)
}

func (p *KafkaPublisher) PublishChunk(ctx context.Context, chunk *pb.DataChunk) error {
	if p == nil || p.writer == nil {
		return errors.New("kafka publisher is not initialized")
	}
	body, err := proto.Marshal(chunk)
	if err != nil {
		return fmt.Errorf("marshal data chunk: %w", err)
	}
	message := kafka.Message{
		Key:   kafkaMessageKey(p.keyMode, chunk),
		Value: body,
		Headers: []kafka.Header{
			{Key: "run_id", Value: []byte(chunk.GetRunId())},
			{Key: "sequence", Value: []byte(strconv.FormatUint(chunk.GetSequence(), 10))},
			{Key: "producer_worker", Value: []byte(strconv.FormatUint(chunk.GetProducerWorker(), 10))},
		},
	}

	p.mu.Lock()
	defer p.mu.Unlock()

	if len(p.pending) > 0 && time.Since(p.lastFlushAt) >= p.flushInterval {
		if err := p.flushLocked(ctx); err != nil {
			return err
		}
	}

	p.pending = append(p.pending, message)
	p.pendingBytes += len(message.Key) + len(message.Value)
	if p.lastFlushAt.IsZero() {
		p.lastFlushAt = time.Now()
	}

	if len(p.pending) < p.maxBatchSize && p.pendingBytes < p.maxBatchBytes {
		return nil
	}

	return p.flushLocked(ctx)
}

func kafkaMessageKey(mode string, chunk *pb.DataChunk) []byte {
	switch mode {
	case "run":
		return []byte(chunk.GetRunId())
	case "none":
		return nil
	default:
		return []byte(strconv.FormatUint(chunk.GetProducerWorker(), 10))
	}
}

func kafkaBalancer(keyMode string) kafka.Balancer {
	if keyMode == "none" {
		return &kafka.LeastBytes{}
	}
	return &kafka.Hash{}
}

func kafkaRequiredAcks(value string) kafka.RequiredAcks {
	switch value {
	case "none":
		return kafka.RequireNone
	case "all":
		return kafka.RequireAll
	default:
		return kafka.RequireOne
	}
}

func kafkaCompression(value string) kafka.Compression {
	switch value {
	case "gzip":
		return kafka.Gzip
	case "snappy":
		return kafka.Snappy
	case "lz4":
		return kafka.Lz4
	case "zstd":
		return kafka.Zstd
	default:
		return 0
	}
}

func (p *KafkaPublisher) flush(ctx context.Context) error {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.flushLocked(ctx)
}

func (p *KafkaPublisher) flushLocked(ctx context.Context) error {
	if len(p.pending) == 0 {
		return nil
	}
	if err := p.writer.WriteMessages(ctx, p.pending...); err != nil {
		return fmt.Errorf("publish to kafka topic %q: %w", p.topic, err)
	}
	p.pending = p.pending[:0]
	p.pendingBytes = 0
	p.lastFlushAt = time.Now()
	return nil
}

func ensureKafkaTopic(cfg KafkaConfig, topic string) error {
	if len(cfg.Brokers) == 0 {
		return errors.New("kafka broker list is empty")
	}
	conn, err := kafka.Dial("tcp", cfg.Brokers[0])
	if err != nil {
		return fmt.Errorf("connect kafka broker %q: %w", cfg.Brokers[0], err)
	}
	defer conn.Close()

	controller, err := conn.Controller()
	if err != nil {
		return fmt.Errorf("lookup kafka controller: %w", err)
	}
	controllerAddr := net.JoinHostPort(controller.Host, strconv.Itoa(controller.Port))
	controllerConn, err := kafka.Dial("tcp", controllerAddr)
	if err != nil {
		return fmt.Errorf("connect kafka controller %q: %w", controllerAddr, err)
	}
	defer controllerConn.Close()

	err = controllerConn.CreateTopics(kafka.TopicConfig{
		Topic:             topic,
		NumPartitions:     cfg.TopicPartitions,
		ReplicationFactor: cfg.TopicReplicationFactor,
	})
	if err != nil && !strings.Contains(strings.ToLower(err.Error()), "already exists") {
		return fmt.Errorf("create kafka topic %q: %w", topic, err)
	}

	deadline := time.Now().Add(kafkaTopicReadyWait)
	for {
		partitions, metadataErr := conn.ReadPartitions(topic)
		if metadataErr == nil && kafkaTopicHasPartitions(partitions, topic, cfg.TopicPartitions) {
			return nil
		}
		if time.Now().After(deadline) {
			if metadataErr != nil {
				return fmt.Errorf("wait for Kafka topic %q metadata: %w", topic, metadataErr)
			}
			return fmt.Errorf(
				"wait for Kafka topic %q metadata: expected %d partitions, observed %d",
				topic,
				cfg.TopicPartitions,
				len(partitions),
			)
		}
		time.Sleep(100 * time.Millisecond)
	}
}

func kafkaTopicHasPartitions(partitions []kafka.Partition, topic string, expected int) bool {
	seen := make(map[int]struct{}, expected)
	for _, partition := range partitions {
		if partition.Topic == topic {
			seen[partition.ID] = struct{}{}
		}
	}
	return len(seen) >= expected
}

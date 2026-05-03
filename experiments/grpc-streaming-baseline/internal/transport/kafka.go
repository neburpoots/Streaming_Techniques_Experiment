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
	maxBatchBytes int
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
	kafkaBatchSize         = 256
	kafkaBatchBytes        = 1 * 1024 * 1024
	kafkaBatchTimeout      = 5 * time.Millisecond
	kafkaCommitInterval    = 250 * time.Millisecond
	kafkaFlushTimeout      = 5 * time.Second
	kafkaCommitTimeout     = 5 * time.Second
	kafkaReadMaxWait       = 250 * time.Millisecond
	kafkaReadMinBytes      = 64 * 1024
	kafkaReadMaxBytes      = 64 * 1024 * 1024
	kafkaWriterAttempts    = 10
	kafkaWriterQueueLength = 2 * kafkaBatchSize
)

func NewKafkaPublisher(cfg KafkaConfig, topic string) (*KafkaPublisher, error) {
	if err := ensureKafkaTopic(cfg, topic); err != nil {
		return nil, err
	}
	writer := &kafka.Writer{
		Addr:                   kafka.TCP(cfg.Brokers...),
		Topic:                  topic,
		Balancer:               &kafka.Hash{},
		RequiredAcks:           kafka.RequireOne,
		BatchSize:              kafkaBatchSize,
		BatchBytes:             kafkaBatchBytes,
		BatchTimeout:           kafkaBatchTimeout,
		MaxAttempts:            kafkaWriterAttempts,
		AllowAutoTopicCreation: true,
	}
	publisher := &KafkaPublisher{
		writer:        writer,
		topic:         topic,
		flushInterval: kafkaBatchTimeout,
		maxBatchBytes: kafkaBatchBytes,
		closeCh:       make(chan struct{}),
		flushDone:     make(chan struct{}),
		pending:       make([]kafka.Message, 0, kafkaWriterQueueLength),
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
		CommitInterval: kafkaCommitInterval,
		QueueCapacity:  kafkaWriterQueueLength,
		MinBytes:       kafkaReadMinBytes,
		MaxBytes:       kafkaReadMaxBytes,
		MaxWait:        kafkaReadMaxWait,
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
		Key:   []byte(strconv.FormatUint(chunk.GetProducerWorker(), 10)),
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

	if len(p.pending) < kafkaBatchSize && p.pendingBytes < p.maxBatchBytes {
		return nil
	}

	return p.flushLocked(ctx)
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
	if err == nil || strings.Contains(strings.ToLower(err.Error()), "already exists") {
		return nil
	}
	return fmt.Errorf("create kafka topic %q: %w", topic, err)
}

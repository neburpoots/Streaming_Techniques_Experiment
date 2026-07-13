package transport

import (
	"fmt"
	"net/url"
	"strings"
	"time"

	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/config"
)

const (
	ModeClientStreaming = "client-streaming"
	ModeUnary           = "unary"
	ModeBatchedUnary    = "batched-unary"
	ModeRabbitMQStreams = "rabbitmq-streams"
	ModeNATSJetStream   = "nats-jetstream"
	ModeKafka           = "kafka"
)

const (
	DefaultNATSAckWait        = 120 * time.Second
	DefaultNATSMaxAckPending  = 4096
	DefaultNATSFetchBatchSize = 64
	DefaultNATSFetchMaxWait   = 500 * time.Millisecond
)

type RabbitMQConfig struct {
	Host                        string
	AMQPPort                    int
	StreamPort                  int
	ManagementPort              int
	User                        string
	Password                    string
	VHost                       string
	ProducerToTransformerStream string
	TransformerToSinkStream     string
}

type NATSConfig struct {
	URL                          string
	ProducerToTransformerSubject string
	TransformerToSinkSubject     string
	StreamReplicas               int
	StreamMaxBytes               int64
	AckWait                      time.Duration
	MaxAckPending                int
	FetchBatchSize               int
	FetchMaxWait                 time.Duration
}

type KafkaConfig struct {
	Brokers                    []string
	ProducerToTransformerTopic string
	TransformerToSinkTopic     string
	TopicPartitions            int
	TopicReplicationFactor     int
	BatchSize                  int
	BatchBytes                 int
	BatchTimeout               time.Duration
	CommitInterval             time.Duration
	QueueCapacity              int
	ReadMinBytes               int
	ReadMaxBytes               int
	ReadMaxWait                time.Duration
	RequiredAcks               string
	Compression                string
	KeyMode                    string
}

func SupportedModes() []string {
	return []string{ModeClientStreaming, ModeUnary, ModeBatchedUnary, ModeRabbitMQStreams, ModeNATSJetStream, ModeKafka}
}

func IsSupportedMode(mode string) bool {
	for _, supportedMode := range SupportedModes() {
		if mode == supportedMode {
			return true
		}
	}
	return false
}

func ShortName(mode string) string {
	switch mode {
	case ModeClientStreaming:
		return "stream"
	case ModeUnary:
		return "unary"
	case ModeBatchedUnary:
		return "bunary"
	case ModeRabbitMQStreams:
		return "rmqs"
	case ModeNATSJetStream:
		return "nats"
	case ModeKafka:
		return "kafka"
	default:
		return mode
	}
}

func LoadRabbitMQConfig() (RabbitMQConfig, error) {
	amqpPort, err := config.Int("RABBITMQ_AMQP_PORT", 5672)
	if err != nil {
		return RabbitMQConfig{}, fmt.Errorf("parse RABBITMQ_AMQP_PORT: %w", err)
	}
	streamPort, err := config.Int("RABBITMQ_STREAM_PORT", 5552)
	if err != nil {
		return RabbitMQConfig{}, fmt.Errorf("parse RABBITMQ_STREAM_PORT: %w", err)
	}
	managementPort, err := config.Int("RABBITMQ_MANAGEMENT_PORT", 15672)
	if err != nil {
		return RabbitMQConfig{}, fmt.Errorf("parse RABBITMQ_MANAGEMENT_PORT: %w", err)
	}

	return RabbitMQConfig{
		Host:                        config.String("RABBITMQ_HOST", "rabbitmq"),
		AMQPPort:                    amqpPort,
		StreamPort:                  streamPort,
		ManagementPort:              managementPort,
		User:                        config.String("RABBITMQ_USER", "guest"),
		Password:                    config.String("RABBITMQ_PASSWORD", "guest"),
		VHost:                       config.String("RABBITMQ_VHOST", "/"),
		ProducerToTransformerStream: config.String("RABBITMQ_PRODUCER_TO_TRANSFORMER_STREAM", "producer-to-transformer"),
		TransformerToSinkStream:     config.String("RABBITMQ_TRANSFORMER_TO_SINK_STREAM", "transformer-to-sink"),
	}, nil
}

func LoadNATSConfig() NATSConfig {
	streamReplicas, err := config.Int("NATS_STREAM_REPLICAS", 1)
	if err != nil || streamReplicas <= 0 {
		streamReplicas = 1
	}
	streamMaxBytes, err := config.Uint64("NATS_STREAM_MAX_BYTES", 1024*1024*1024)
	if err != nil || streamMaxBytes == 0 {
		streamMaxBytes = 1024 * 1024 * 1024
	}
	ackWait, err := config.DurationMillis("NATS_ACK_WAIT_MS", DefaultNATSAckWait)
	if err != nil || ackWait <= 0 {
		ackWait = DefaultNATSAckWait
	}
	maxAckPending, err := config.Int("NATS_MAX_ACK_PENDING", DefaultNATSMaxAckPending)
	if err != nil || maxAckPending <= 0 {
		maxAckPending = DefaultNATSMaxAckPending
	}
	fetchBatchSize, err := config.Int("NATS_FETCH_BATCH_SIZE", DefaultNATSFetchBatchSize)
	if err != nil || fetchBatchSize <= 0 {
		fetchBatchSize = DefaultNATSFetchBatchSize
	}
	fetchMaxWait, err := config.DurationMillis("NATS_FETCH_MAX_WAIT_MS", DefaultNATSFetchMaxWait)
	if err != nil || fetchMaxWait <= 0 {
		fetchMaxWait = DefaultNATSFetchMaxWait
	}
	return NATSConfig{
		URL:                          config.String("NATS_URL", "nats://nats:4222"),
		ProducerToTransformerSubject: config.String("NATS_PRODUCER_TO_TRANSFORMER_SUBJECT", "producer.to.transformer"),
		TransformerToSinkSubject:     config.String("NATS_TRANSFORMER_TO_SINK_SUBJECT", "transformer.to.sink"),
		StreamReplicas:               streamReplicas,
		StreamMaxBytes:               int64(streamMaxBytes),
		AckWait:                      ackWait,
		MaxAckPending:                maxAckPending,
		FetchBatchSize:               fetchBatchSize,
		FetchMaxWait:                 fetchMaxWait,
	}
}

func LoadKafkaConfig() KafkaConfig {
	brokers := splitList(config.String("KAFKA_BROKERS", "kafka:9092"))
	if len(brokers) == 0 {
		brokers = []string{"kafka:9092"}
	}
	topicPartitions, err := config.Int("KAFKA_TOPIC_PARTITIONS", 16)
	if err != nil || topicPartitions <= 0 {
		topicPartitions = 16
	}
	topicReplicationFactor, err := config.Int("KAFKA_TOPIC_REPLICATION_FACTOR", 1)
	if err != nil || topicReplicationFactor <= 0 {
		topicReplicationFactor = 1
	}
	batchSize, err := config.Int("KAFKA_BATCH_SIZE", 256)
	if err != nil || batchSize <= 0 {
		batchSize = 256
	}
	batchBytes, err := config.Int("KAFKA_BATCH_BYTES", 1024*1024)
	if err != nil || batchBytes <= 0 {
		batchBytes = 1024 * 1024
	}
	batchTimeout, err := config.DurationMillis("KAFKA_BATCH_TIMEOUT_MS", 5*time.Millisecond)
	if err != nil || batchTimeout <= 0 {
		batchTimeout = 5 * time.Millisecond
	}
	commitInterval, err := config.DurationMillis("KAFKA_COMMIT_INTERVAL_MS", 250*time.Millisecond)
	if err != nil || commitInterval < 0 {
		commitInterval = 250 * time.Millisecond
	}
	queueCapacity, err := config.Int("KAFKA_QUEUE_CAPACITY", 512)
	if err != nil || queueCapacity <= 0 {
		queueCapacity = 512
	}
	readMinBytes, err := config.Int("KAFKA_FETCH_MIN_BYTES", 64*1024)
	if err != nil || readMinBytes <= 0 {
		readMinBytes = 64 * 1024
	}
	readMaxBytes, err := config.Int("KAFKA_FETCH_MAX_BYTES", 64*1024*1024)
	if err != nil || readMaxBytes < readMinBytes {
		readMaxBytes = 64 * 1024 * 1024
	}
	readMaxWait, err := config.DurationMillis("KAFKA_FETCH_MAX_WAIT_MS", 250*time.Millisecond)
	if err != nil || readMaxWait <= 0 {
		readMaxWait = 250 * time.Millisecond
	}
	requiredAcks := strings.ToLower(config.String("KAFKA_REQUIRED_ACKS", "one"))
	switch requiredAcks {
	case "none", "one", "all":
	default:
		requiredAcks = "one"
	}
	compression := strings.ToLower(config.String("KAFKA_COMPRESSION", "none"))
	switch compression {
	case "none", "gzip", "snappy", "lz4", "zstd":
	default:
		compression = "none"
	}
	keyMode := strings.ToLower(config.String("KAFKA_KEY_MODE", "worker"))
	switch keyMode {
	case "worker", "run", "none":
	default:
		keyMode = "worker"
	}
	return KafkaConfig{
		Brokers:                    brokers,
		ProducerToTransformerTopic: config.String("KAFKA_PRODUCER_TO_TRANSFORMER_TOPIC", "producer-to-transformer"),
		TransformerToSinkTopic:     config.String("KAFKA_TRANSFORMER_TO_SINK_TOPIC", "transformer-to-sink"),
		TopicPartitions:            topicPartitions,
		TopicReplicationFactor:     topicReplicationFactor,
		BatchSize:                  batchSize,
		BatchBytes:                 batchBytes,
		BatchTimeout:               batchTimeout,
		CommitInterval:             commitInterval,
		QueueCapacity:              queueCapacity,
		ReadMinBytes:               readMinBytes,
		ReadMaxBytes:               readMaxBytes,
		ReadMaxWait:                readMaxWait,
		RequiredAcks:               requiredAcks,
		Compression:                compression,
		KeyMode:                    keyMode,
	}
}

func (cfg RabbitMQConfig) AMQPURL() string {
	credentials := url.QueryEscape(cfg.User) + ":" + url.QueryEscape(cfg.Password)
	host := fmt.Sprintf("%s:%d", cfg.Host, cfg.AMQPPort)
	vhost := strings.TrimPrefix(cfg.VHost, "/")
	if cfg.VHost == "" || cfg.VHost == "/" {
		return fmt.Sprintf("amqp://%s@%s/", credentials, host)
	}
	return fmt.Sprintf("amqp://%s@%s/%s", credentials, host, url.PathEscape(vhost))
}

func (cfg NATSConfig) ProducerToTransformerRunWorkerStream(runID string, worker int) string {
	return natsStreamName(cfg.ProducerToTransformerSubject, runID, worker)
}

func (cfg NATSConfig) TransformerToSinkRunWorkerStream(runID string, worker int) string {
	return natsStreamName(cfg.TransformerToSinkSubject, runID, worker)
}

func (cfg NATSConfig) ProducerToTransformerRunWorkerSubject(runID string, worker int) string {
	return natsSubjectName(cfg.ProducerToTransformerSubject, runID, worker)
}

func (cfg NATSConfig) TransformerToSinkRunWorkerSubject(runID string, worker int) string {
	return natsSubjectName(cfg.TransformerToSinkSubject, runID, worker)
}

func (cfg NATSConfig) ConsumerName(role string, runID string, worker int) string {
	return fmt.Sprintf("%s_%s_%02d", sanitizeNATSNamePart(role), sanitizeNATSNamePart(runID), worker)
}

func (cfg KafkaConfig) ProducerToTransformerRunTopic(runID string) string {
	return kafkaRunTopicName(cfg.ProducerToTransformerTopic, runID)
}

func (cfg KafkaConfig) TransformerToSinkRunTopic(runID string) string {
	return kafkaRunTopicName(cfg.TransformerToSinkTopic, runID)
}

func (cfg KafkaConfig) ConsumerGroup(role string, runID string) string {
	return fmt.Sprintf("%s-%s", sanitizeKafkaNamePart(role), sanitizeKafkaNamePart(runID))
}

func (cfg RabbitMQConfig) ProducerToTransformerWorkerStream(worker int) string {
	return cfg.ProducerToTransformerRunWorkerStream("", worker)
}

func (cfg RabbitMQConfig) TransformerToSinkWorkerStream(worker int) string {
	return cfg.TransformerToSinkRunWorkerStream("", worker)
}

func (cfg RabbitMQConfig) ProducerToTransformerRunWorkerStream(runID string, worker int) string {
	return runScopedWorkerStreamName(cfg.ProducerToTransformerStream, runID, worker)
}

func (cfg RabbitMQConfig) TransformerToSinkRunWorkerStream(runID string, worker int) string {
	return runScopedWorkerStreamName(cfg.TransformerToSinkStream, runID, worker)
}

func runScopedWorkerStreamName(base string, runID string, worker int) string {
	if runID == "" {
		return fmt.Sprintf("%s-worker-%02d", base, worker)
	}
	return fmt.Sprintf("%s-%s-worker-%02d", base, sanitizeRabbitMQNamePart(runID), worker)
}

func sanitizeRabbitMQNamePart(value string) string {
	replacer := strings.NewReplacer("/", "-", ":", "-", " ", "-", ".", "-")
	sanitized := replacer.Replace(strings.TrimSpace(value))
	if sanitized == "" {
		return "default"
	}
	return sanitized
}

func natsStreamName(base string, runID string, worker int) string {
	return fmt.Sprintf("%s_%s_worker_%02d", sanitizeNATSNamePart(base), sanitizeNATSNamePart(runID), worker)
}

func natsSubjectName(base string, runID string, worker int) string {
	return fmt.Sprintf("%s.%s.worker.%02d", sanitizeNATSSubjectPart(base), sanitizeNATSSubjectPart(runID), worker)
}

func kafkaRunTopicName(base string, runID string) string {
	return fmt.Sprintf("%s-%s", sanitizeKafkaNamePart(base), sanitizeKafkaNamePart(runID))
}

func sanitizeNATSNamePart(value string) string {
	replacer := strings.NewReplacer("/", "_", "\\", "_", ":", "_", " ", "_", ".", "_", "*", "_", ">", "_", "-", "_")
	sanitized := strings.Trim(replacer.Replace(strings.TrimSpace(value)), "_")
	if sanitized == "" {
		return "default"
	}
	return sanitized
}

func sanitizeNATSSubjectPart(value string) string {
	replacer := strings.NewReplacer("/", ".", "\\", ".", ":", ".", " ", ".", "*", "_", ">", "_")
	sanitized := strings.Trim(replacer.Replace(strings.TrimSpace(value)), ".")
	if sanitized == "" {
		return "default"
	}
	return sanitized
}

func sanitizeKafkaNamePart(value string) string {
	replacer := strings.NewReplacer("/", "-", "\\", "-", ":", "-", " ", "-", "*", "-", ">", "-")
	sanitized := strings.Trim(replacer.Replace(strings.TrimSpace(value)), "-.")
	if sanitized == "" {
		return "default"
	}
	return sanitized
}

func splitList(value string) []string {
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

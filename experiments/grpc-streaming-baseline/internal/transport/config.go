package transport

import (
	"fmt"
	"net/url"
	"strings"

	"github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/config"
)

const (
	ModeClientStreaming = "client-streaming"
	ModeUnary           = "unary"
	ModeRabbitMQStreams = "rabbitmq-streams"
	ModeNATSJetStream   = "nats-jetstream"
	ModeKafka           = "kafka"
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
}

type KafkaConfig struct {
	Brokers                    []string
	ProducerToTransformerTopic string
	TransformerToSinkTopic     string
	TopicPartitions            int
}

func SupportedModes() []string {
	return []string{ModeClientStreaming, ModeUnary, ModeRabbitMQStreams, ModeNATSJetStream, ModeKafka}
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
	return NATSConfig{
		URL:                          config.String("NATS_URL", "nats://nats:4222"),
		ProducerToTransformerSubject: config.String("NATS_PRODUCER_TO_TRANSFORMER_SUBJECT", "producer.to.transformer"),
		TransformerToSinkSubject:     config.String("NATS_TRANSFORMER_TO_SINK_SUBJECT", "transformer.to.sink"),
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
	return KafkaConfig{
		Brokers:                    brokers,
		ProducerToTransformerTopic: config.String("KAFKA_PRODUCER_TO_TRANSFORMER_TOPIC", "producer-to-transformer"),
		TransformerToSinkTopic:     config.String("KAFKA_TRANSFORMER_TO_SINK_TOPIC", "transformer-to-sink"),
		TopicPartitions:            topicPartitions,
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

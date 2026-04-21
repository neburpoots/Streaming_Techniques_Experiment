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

func SupportedModes() []string {
	return []string{ModeClientStreaming, ModeUnary, ModeRabbitMQStreams}
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

func (cfg RabbitMQConfig) AMQPURL() string {
	credentials := url.QueryEscape(cfg.User) + ":" + url.QueryEscape(cfg.Password)
	host := fmt.Sprintf("%s:%d", cfg.Host, cfg.AMQPPort)
	vhost := strings.TrimPrefix(cfg.VHost, "/")
	if cfg.VHost == "" || cfg.VHost == "/" {
		return fmt.Sprintf("amqp://%s@%s/", credentials, host)
	}
	return fmt.Sprintf("amqp://%s@%s/%s", credentials, host, url.PathEscape(vhost))
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

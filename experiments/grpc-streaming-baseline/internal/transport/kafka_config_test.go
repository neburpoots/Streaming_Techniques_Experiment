package transport

import (
	"testing"
	"time"

	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"github.com/segmentio/kafka-go"
)

func TestLoadKafkaConfigUsesTuningEnvironment(t *testing.T) {
	t.Setenv("KAFKA_TOPIC_PARTITIONS", "8")
	t.Setenv("KAFKA_BATCH_SIZE", "512")
	t.Setenv("KAFKA_BATCH_BYTES", "2097152")
	t.Setenv("KAFKA_BATCH_TIMEOUT_MS", "20")
	t.Setenv("KAFKA_COMMIT_INTERVAL_MS", "100")
	t.Setenv("KAFKA_QUEUE_CAPACITY", "1024")
	t.Setenv("KAFKA_FETCH_MIN_BYTES", "1024")
	t.Setenv("KAFKA_FETCH_MAX_BYTES", "33554432")
	t.Setenv("KAFKA_FETCH_MAX_WAIT_MS", "25")
	t.Setenv("KAFKA_REQUIRED_ACKS", "all")
	t.Setenv("KAFKA_COMPRESSION", "lz4")
	t.Setenv("KAFKA_KEY_MODE", "run")

	cfg := LoadKafkaConfig()
	if cfg.TopicPartitions != 8 || cfg.BatchSize != 512 || cfg.BatchBytes != 2097152 {
		t.Fatalf("unexpected Kafka sizing config: %+v", cfg)
	}
	if cfg.BatchTimeout != 20*time.Millisecond || cfg.CommitInterval != 100*time.Millisecond {
		t.Fatalf("unexpected Kafka timing config: %+v", cfg)
	}
	if cfg.QueueCapacity != 1024 || cfg.ReadMinBytes != 1024 || cfg.ReadMaxBytes != 33554432 {
		t.Fatalf("unexpected Kafka reader config: %+v", cfg)
	}
	if cfg.ReadMaxWait != 25*time.Millisecond || cfg.RequiredAcks != "all" || cfg.Compression != "lz4" || cfg.KeyMode != "run" {
		t.Fatalf("unexpected Kafka behavior config: %+v", cfg)
	}
}

func TestKafkaMessageKeyModes(t *testing.T) {
	chunk := &pb.DataChunk{RunId: "run-a", ProducerWorker: 7}
	if got := string(kafkaMessageKey("worker", chunk)); got != "7" {
		t.Fatalf("worker key = %q, want 7", got)
	}
	if got := string(kafkaMessageKey("run", chunk)); got != "run-a" {
		t.Fatalf("run key = %q, want run-a", got)
	}
	if got := kafkaMessageKey("none", chunk); got != nil {
		t.Fatalf("none key = %q, want nil", got)
	}
}

func TestKafkaTuningMappings(t *testing.T) {
	if kafkaRequiredAcks("all") != kafka.RequireAll || kafkaRequiredAcks("one") != kafka.RequireOne || kafkaRequiredAcks("none") != kafka.RequireNone {
		t.Fatal("Kafka acknowledgement mapping is incorrect")
	}
	if kafkaCompression("lz4") != kafka.Lz4 || kafkaCompression("none") != 0 {
		t.Fatal("Kafka compression mapping is incorrect")
	}
	if _, ok := kafkaBalancer("none").(*kafka.LeastBytes); !ok {
		t.Fatal("unkeyed Kafka messages should use LeastBytes balancing")
	}
	if _, ok := kafkaBalancer("worker").(*kafka.Hash); !ok {
		t.Fatal("keyed Kafka messages should use hash balancing")
	}
}

func TestKafkaTopicHasExpectedPartitions(t *testing.T) {
	partitions := []kafka.Partition{
		{Topic: "target", ID: 0},
		{Topic: "target", ID: 1},
		{Topic: "other", ID: 2},
	}
	if !kafkaTopicHasPartitions(partitions, "target", 2) {
		t.Fatal("expected both target partitions to be visible")
	}
	if kafkaTopicHasPartitions(partitions, "target", 3) {
		t.Fatal("must not count partitions belonging to another topic")
	}
}

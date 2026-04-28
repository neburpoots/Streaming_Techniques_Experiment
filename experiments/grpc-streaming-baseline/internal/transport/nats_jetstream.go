package transport

import (
	"context"
	"errors"
	"fmt"
	"io"
	"sync"
	"time"

	"github.com/nats-io/nats.go"
	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	"google.golang.org/protobuf/proto"
)

type NATSJetStreamPublisher struct {
	conn    *nats.Conn
	js      nats.JetStreamContext
	subject string
	state   *natsAsyncPublishState
}

type NATSJetStreamConsumer struct {
	conn    *nats.Conn
	sub     *nats.Subscription
	pending []*nats.Msg
}

type NATSJetStreamDelivery struct {
	msg *nats.Msg
}

type natsAsyncPublishState struct {
	mu  sync.Mutex
	err error
}

const (
	natsConnectTimeout           = 10 * time.Second
	natsPublishTimeout           = 30 * time.Second
	natsPublishCompleteTimeout   = 30 * time.Second
	natsPublishAsyncMaxPending   = 2048
	natsFetchBatchSize           = 64
	natsFetchMaxWait             = 25 * time.Millisecond
	natsPullMaxWaiting           = 8
	natsMaxAckPending            = 4096
	natsConsumerPendingMsgLimit  = 8192
	natsConsumerPendingBytesLimit = 128 * 1024 * 1024
	natsAckWait                  = 30 * time.Second
	natsMaxDeliver               = 20
	natsStreamMaxBytes           = 512 * 1024 * 1024
)

func NewNATSJetStreamPublisher(cfg NATSConfig, streamName string, subject string) (*NATSJetStreamPublisher, error) {
	state := &natsAsyncPublishState{}
	conn, js, err := openNATSJetStream(
		cfg,
		nats.PublishAsyncMaxPending(natsPublishAsyncMaxPending),
		nats.PublishAsyncTimeout(natsPublishTimeout),
		nats.PublishAsyncErrHandler(func(_ nats.JetStream, msg *nats.Msg, err error) {
			if err == nil {
				return
			}
			state.set(fmt.Errorf("publish to nats subject %q: %w", msg.Subject, err))
		}),
	)
	if err != nil {
		return nil, err
	}
	if err := ensureNATSStream(js, streamName, subject); err != nil {
		conn.Close()
		return nil, err
	}
	return &NATSJetStreamPublisher{conn: conn, js: js, subject: subject, state: state}, nil
}

func NewNATSJetStreamConsumer(cfg NATSConfig, streamName string, subject string, consumerName string) (*NATSJetStreamConsumer, error) {
	conn, js, err := openNATSJetStream(cfg)
	if err != nil {
		return nil, err
	}
	if err := ensureNATSStream(js, streamName, subject); err != nil {
		conn.Close()
		return nil, err
	}
	sub, err := js.PullSubscribe(
		subject,
		consumerName,
		nats.BindStream(streamName),
		nats.ManualAck(),
		nats.AckExplicit(),
		nats.DeliverAll(),
		nats.ConsumerMemoryStorage(),
		nats.AckWait(natsAckWait),
		nats.MaxAckPending(natsMaxAckPending),
		nats.MaxDeliver(natsMaxDeliver),
		nats.MaxRequestBatch(natsFetchBatchSize),
		nats.MaxRequestExpires(natsFetchMaxWait),
		nats.PullMaxWaiting(natsPullMaxWaiting),
	)
	if err != nil {
		conn.Close()
		return nil, fmt.Errorf("create nats pull consumer %q on %q: %w", consumerName, streamName, err)
	}
	if err := sub.SetPendingLimits(natsConsumerPendingMsgLimit, natsConsumerPendingBytesLimit); err != nil {
		_ = sub.Unsubscribe()
		conn.Close()
		return nil, fmt.Errorf("configure nats pull consumer %q pending limits: %w", consumerName, err)
	}
	return &NATSJetStreamConsumer{conn: conn, sub: sub}, nil
}

func (p *NATSJetStreamPublisher) PublishChunk(ctx context.Context, chunk *pb.DataChunk) error {
	if p == nil || p.js == nil {
		return errors.New("nats jetstream publisher is not initialized")
	}
	if err := p.asyncPublishError(); err != nil {
		return err
	}
	body, err := proto.Marshal(chunk)
	if err != nil {
		return fmt.Errorf("marshal data chunk: %w", err)
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	msg := &nats.Msg{
		Subject: p.subject,
		Header: nats.Header{
			"run_id":          []string{chunk.GetRunId()},
			"sequence":        []string{fmt.Sprintf("%d", chunk.GetSequence())},
			"producer_worker": []string{fmt.Sprintf("%d", chunk.GetProducerWorker())},
		},
		Data: body,
	}
	_, err = p.js.PublishMsgAsync(msg, nats.MsgId(fmt.Sprintf("%s-%d", chunk.GetRunId(), chunk.GetSequence())))
	if err != nil {
		return fmt.Errorf("publish to nats subject %q: %w", p.subject, err)
	}
	return nil
}

func (p *NATSJetStreamPublisher) Close() error {
	if p == nil {
		return nil
	}
	var closeErr error
	if p.js != nil && p.js.PublishAsyncPending() > 0 {
		select {
		case <-p.js.PublishAsyncComplete():
		case <-time.After(natsPublishCompleteTimeout):
			closeErr = fmt.Errorf("timed out waiting for pending nats publishes on %q", p.subject)
		}
	}
	if err := p.asyncPublishError(); err != nil && closeErr == nil {
		closeErr = err
	}
	if p.js != nil {
		p.js.CleanupPublisher()
	}
	if p.conn != nil {
		p.conn.Close()
	}
	return closeErr
	}

func (c *NATSJetStreamConsumer) ReceiveChunk(ctx context.Context) (*pb.DataChunk, *NATSJetStreamDelivery, error) {
	if c == nil || c.sub == nil {
		return nil, nil, errors.New("nats jetstream consumer is not initialized")
	}
	for {
		if err := ctx.Err(); err != nil {
			return nil, nil, err
		}
		if len(c.pending) == 0 {
		msgs, err := c.sub.Fetch(natsFetchBatchSize, nats.MaxWait(natsFetchMaxWait))
		if err != nil {
			if errors.Is(err, nats.ErrTimeout) {
				continue
			}
			return nil, nil, err
		}
		if len(msgs) == 0 {
			continue
		}
			c.pending = msgs
		}
		msg := c.pending[0]
		c.pending = c.pending[1:]
		chunk := &pb.DataChunk{}
		if err := proto.Unmarshal(msg.Data, chunk); err != nil {
			return nil, nil, fmt.Errorf("unmarshal nats delivery: %w", err)
		}
		return chunk, &NATSJetStreamDelivery{msg: msg}, nil
	}
}

func (c *NATSJetStreamConsumer) Close() error {
	if c == nil {
		return nil
	}
	if c.sub != nil {
		if err := c.sub.Unsubscribe(); err != nil && !errors.Is(err, nats.ErrConnectionClosed) {
			return err
		}
	}
	if c.conn != nil {
		c.conn.Close()
	}
	return nil
}

func (d *NATSJetStreamDelivery) Commit() error {
	if d == nil || d.msg == nil {
		return nil
	}
	return d.msg.Ack()
}

func openNATSJetStream(cfg NATSConfig, opts ...nats.JSOpt) (*nats.Conn, nats.JetStreamContext, error) {
	conn, err := nats.Connect(cfg.URL, nats.Timeout(natsConnectTimeout), nats.RetryOnFailedConnect(true), nats.MaxReconnects(5))
	if err != nil {
		return nil, nil, fmt.Errorf("connect nats %q: %w", cfg.URL, err)
	}
	js, err := conn.JetStream(opts...)
	if err != nil {
		conn.Close()
		return nil, nil, fmt.Errorf("open nats jetstream context: %w", err)
	}
	return conn, js, nil
}

func (p *NATSJetStreamPublisher) asyncPublishError() error {
	if p == nil || p.state == nil {
		return nil
	}
	return p.state.get()
}

func (s *natsAsyncPublishState) set(err error) {
	if s == nil || err == nil {
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.err == nil {
		s.err = err
	}
}

func (s *natsAsyncPublishState) get() error {
	if s == nil {
		return nil
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.err
}

func ensureNATSStream(js nats.JetStreamContext, streamName string, subject string) error {
	if _, err := js.StreamInfo(streamName); err == nil {
		return nil
	} else if !errors.Is(err, nats.ErrStreamNotFound) {
		return fmt.Errorf("lookup nats stream %q: %w", streamName, err)
	}

	_, err := js.AddStream(&nats.StreamConfig{
		Name:      streamName,
		Subjects:  []string{subject},
		Storage:   nats.FileStorage,
		Retention: nats.LimitsPolicy,
		MaxBytes:  natsStreamMaxBytes,
		Replicas:  1,
	})
	if err != nil {
		if errors.Is(err, nats.ErrStreamNameAlreadyInUse) || errors.Is(err, io.EOF) {
			return nil
		}
		return fmt.Errorf("create nats stream %q for subject %q: %w", streamName, subject, err)
	}
	return nil
}

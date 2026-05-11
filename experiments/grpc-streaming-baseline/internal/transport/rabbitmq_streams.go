package transport

import (
	"context"
	"errors"
	"fmt"
	"io"
	"sync"
	"time"

	pb "github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline/internal/pb"
	streamamqp "github.com/rabbitmq/rabbitmq-stream-go-client/pkg/amqp"
	"github.com/rabbitmq/rabbitmq-stream-go-client/pkg/stream"
	"google.golang.org/protobuf/proto"
)

type RabbitMQStreamPublisher struct {
	streamName  string
	env         *stream.Environment
	producer    *stream.Producer
	confirmMu   sync.Mutex
	confirmErr  error
	pendingAcks map[int64]chan error
	pendingZero chan struct{}
	confirmSlots chan struct{}
	confirmDone chan struct{}
}

type RabbitMQStreamConsumer struct {
	streamName   string
	consumerName string
	env          *stream.Environment
	consumer     *stream.Consumer
	deliveries   chan *RabbitMQStreamDelivery
	errs         chan error
	closed       chan struct{}
}

type RabbitMQStreamDelivery struct {
	chunk    *pb.DataChunk
	offset   int64
	consumer *stream.Consumer

	commitOnce sync.Once
	commitErr  error
}

const (
	rabbitMQAutoCommitCount      = 100
	rabbitMQAutoCommitFlushAfter = 5 * time.Second
	rabbitMQInitialCredits       = 64
	rabbitMQConfirmationTimeout  = 10 * time.Second
	rabbitMQMaxPendingConfirms   = 64
)

func NewRabbitMQStreamPublisher(cfg RabbitMQConfig, streamName string) (*RabbitMQStreamPublisher, error) {
	env, err := openRabbitMQEnvironment(cfg)
	if err != nil {
		return nil, err
	}

	if err := declareRabbitMQStream(env, streamName); err != nil {
		_ = env.Close()
		return nil, err
	}

	producer, err := env.NewProducer(streamName, stream.NewProducerOptions().
		SetBatchSize(100).
		SetConfirmationTimeOut(rabbitMQConfirmationTimeout))
	if err != nil {
		_ = env.Close()
		return nil, fmt.Errorf("create stream producer for %q: %w", streamName, err)
	}

	publisher := &RabbitMQStreamPublisher{
		streamName:  streamName,
		env:         env,
		producer:    producer,
		pendingAcks: make(map[int64]chan error),
		pendingZero: closedSignal(),
		confirmSlots: make(chan struct{}, rabbitMQMaxPendingConfirms),
		confirmDone: make(chan struct{}),
	}

	go publisher.trackConfirmations(producer.NotifyPublishConfirmation())
	go publisher.trackClose(producer.NotifyClose())

	return publisher, nil
}

func NewRabbitMQStreamConsumer(cfg RabbitMQConfig, streamName string, consumerName string) (*RabbitMQStreamConsumer, error) {
	env, err := openRabbitMQEnvironment(cfg)
	if err != nil {
		return nil, err
	}

	if err := declareRabbitMQStream(env, streamName); err != nil {
		_ = env.Close()
		return nil, err
	}

	deliveries := make(chan *RabbitMQStreamDelivery, 64)
	errCh := make(chan error, 1)
	closed := make(chan struct{})

	consumer := &RabbitMQStreamConsumer{
		streamName:   streamName,
		consumerName: consumerName,
		env:          env,
		deliveries:   deliveries,
		errs:         errCh,
		closed:       closed,
	}

	offsetSpec, err := resolveRabbitMQOffset(env, consumerName, streamName)
	if err != nil {
		close(closed)
		_ = env.Close()
		return nil, err
	}

	streamConsumer, err := env.NewConsumer(
		streamName,
		consumer.handleMessage,
		stream.NewConsumerOptions().
			SetConsumerName(consumerName).
			SetCRCCheck(false).
			SetInitialCredits(rabbitMQInitialCredits).
			SetAutoCommit(stream.NewAutoCommitStrategy().
				SetCountBeforeStorage(rabbitMQAutoCommitCount).
				SetFlushInterval(rabbitMQAutoCommitFlushAfter)).
			SetOffset(offsetSpec),
	)
	if err != nil {
		close(closed)
		_ = env.Close()
		return nil, fmt.Errorf("create stream consumer for %q: %w", streamName, err)
	}
	consumer.consumer = streamConsumer

	go consumer.trackClose(streamConsumer.NotifyClose())

	return consumer, nil
}

func (p *RabbitMQStreamPublisher) PublishChunk(ctx context.Context, chunk *pb.DataChunk) error {
	if p == nil || p.producer == nil {
		return errors.New("rabbitmq publisher is not initialized")
	}
	if err := p.confirmationError(); err != nil {
		return err
	}

	body, err := proto.Marshal(chunk)
	if err != nil {
		return fmt.Errorf("marshal data chunk: %w", err)
	}

	message := streamamqp.NewMessage(body)
	message.Properties = &streamamqp.MessageProperties{
		MessageID: fmt.Sprintf("%s-%d", chunk.GetRunId(), chunk.GetSequence()),
	}
	publishID := int64(chunk.GetSequence())
	message.SetPublishingId(publishID)
	message.ApplicationProperties = map[string]any{
		"run_id":               chunk.GetRunId(),
		"sequence":             int64(chunk.GetSequence()),
		"producer_worker":      int64(chunk.GetProducerWorker()),
		"created_at_unix_nano": chunk.GetCreatedAtUnixNano(),
	}

	if err := p.acquireConfirmationSlot(ctx); err != nil {
		return err
	}
	_, err = p.registerPendingConfirmation(publishID)
	if err != nil {
		p.releaseConfirmationSlot()
		return err
	}

	if err := ctx.Err(); err != nil {
		p.cancelPendingConfirmation(publishID)
		return err
	}
	if err := p.producer.Send(message); err != nil {
		p.cancelPendingConfirmation(publishID)
		return fmt.Errorf("publish to %q: %w", p.streamName, err)
	}

	return nil
}

func (p *RabbitMQStreamPublisher) Close() error {
	if p == nil {
		return nil
	}

	var closeErr error
	if err := p.waitForPendingConfirmations(rabbitMQConfirmationTimeout); err != nil {
		closeErr = err
	}
	if p.producer != nil {
		if err := p.producer.Close(); err != nil && closeErr == nil {
			closeErr = err
		}
	}
	if p.confirmDone != nil {
		<-p.confirmDone
	}
	if err := p.confirmationError(); err != nil && closeErr == nil {
		closeErr = err
	}
	if p.env != nil {
		if err := p.env.Close(); err != nil && closeErr == nil {
			closeErr = err
		}
	}
	return closeErr
}

func (c *RabbitMQStreamConsumer) ReceiveChunk(ctx context.Context) (*pb.DataChunk, *RabbitMQStreamDelivery, error) {
	if c == nil || c.consumer == nil {
		return nil, nil, errors.New("rabbitmq consumer is not initialized")
	}

	select {
	case delivery, ok := <-c.deliveries:
		if !ok {
			select {
			case err := <-c.errs:
				if err != nil {
					return nil, nil, err
				}
			default:
			}
			return nil, nil, io.EOF
		}
		return delivery.chunk, delivery, nil
	case err := <-c.errs:
		if err != nil {
			return nil, nil, err
		}
		return nil, nil, io.EOF
	case <-ctx.Done():
		return nil, nil, ctx.Err()
	}
}

func (c *RabbitMQStreamConsumer) Close() error {
	if c == nil {
		return nil
	}

	var closeErr error
	select {
	case <-c.closed:
	default:
		close(c.closed)
	}
	if c.consumer != nil {
		if err := c.consumer.Close(); err != nil {
			closeErr = err
		}
	}
	if c.env != nil {
		if err := c.env.Close(); err != nil && closeErr == nil {
			closeErr = err
		}
	}
	return closeErr
}

func (d *RabbitMQStreamDelivery) Commit() error {
	if d == nil || d.consumer == nil {
		return errors.New("rabbitmq delivery is not initialized")
	}
	d.commitOnce.Do(func() {
		d.commitErr = d.consumer.StoreCustomOffset(d.offset)
	})
	return d.commitErr
}

func openRabbitMQEnvironment(cfg RabbitMQConfig) (*stream.Environment, error) {
	env, err := stream.NewEnvironment(stream.NewEnvironmentOptions().
		SetHost(cfg.Host).
		SetPort(cfg.StreamPort).
		SetUser(cfg.User).
		SetPassword(cfg.Password).
		SetVHost(cfg.VHost).
		SetMaxProducersPerClient(1).
		SetMaxConsumersPerClient(1))
	if err != nil {
		return nil, fmt.Errorf("open rabbitmq streams environment: %w", err)
	}
	return env, nil
}

func declareRabbitMQStream(env *stream.Environment, streamName string) error {
	if err := env.DeclareStream(streamName, stream.NewStreamOptions().SetMaxLengthBytes(stream.ByteCapacity{}.GB(2))); err != nil {
		return fmt.Errorf("declare stream %q: %w", streamName, err)
	}
	return nil
}

func resolveRabbitMQOffset(env *stream.Environment, consumerName string, streamName string) (stream.OffsetSpecification, error) {
	offset, err := env.QueryOffset(consumerName, streamName)
	if err != nil {
		if errors.Is(err, stream.OffsetNotFoundError) {
			return stream.OffsetSpecification{}.First(), nil
		}
		return stream.OffsetSpecification{}, fmt.Errorf("query offset for consumer %q on %q: %w", consumerName, streamName, err)
	}
	return stream.OffsetSpecification{}.Offset(offset + 1), nil
}

func (p *RabbitMQStreamPublisher) trackConfirmations(confirms stream.ChannelPublishConfirm) {
	defer close(p.confirmDone)
	for statuses := range confirms {
		for _, status := range statuses {
			p.resolveConfirmation(status)
		}
	}
}

func (p *RabbitMQStreamPublisher) setConfirmationError(err error) {
	if err == nil {
		return
	}
	p.confirmMu.Lock()
	defer p.confirmMu.Unlock()
	if p.confirmErr == nil {
		p.confirmErr = err
	}
}

func (p *RabbitMQStreamPublisher) confirmationError() error {
	p.confirmMu.Lock()
	defer p.confirmMu.Unlock()
	return p.confirmErr
}

func (p *RabbitMQStreamPublisher) registerPendingConfirmation(publishID int64) (<-chan error, error) {
	p.confirmMu.Lock()
	defer p.confirmMu.Unlock()

	if p.confirmErr != nil {
		return nil, p.confirmErr
	}
	if _, exists := p.pendingAcks[publishID]; exists {
		return nil, fmt.Errorf("duplicate pending publish confirmation for %q publishing id %d", p.streamName, publishID)
	}
	if len(p.pendingAcks) == 0 {
		p.pendingZero = make(chan struct{})
	}

	ackCh := make(chan error, 1)
	p.pendingAcks[publishID] = ackCh
	return ackCh, nil
}

func (p *RabbitMQStreamPublisher) cancelPendingConfirmation(publishID int64) {
	p.confirmMu.Lock()
	ackCh, exists := p.pendingAcks[publishID]
	if exists {
		delete(p.pendingAcks, publishID)
	}
	p.confirmMu.Unlock()

	if exists {
		p.releaseConfirmationSlot()
		close(ackCh)
	}
	p.notifyPendingZero()
}

func (p *RabbitMQStreamPublisher) resolveConfirmation(status *stream.ConfirmationStatus) {
	if status == nil {
		return
	}

	var publishErr error
	if !status.IsConfirmed() {
		publishErr = status.GetError()
		if publishErr == nil {
			publishErr = errors.New("publish confirmation failed")
		}
		publishErr = fmt.Errorf("publish confirmation failed for %q publishing id %d: %w", p.streamName, status.GetPublishingId(), publishErr)
	}
	p.finishPendingConfirmation(status.GetPublishingId(), publishErr)
}

func (p *RabbitMQStreamPublisher) finishPendingConfirmation(publishID int64, err error) {
	p.confirmMu.Lock()
	ackCh, exists := p.pendingAcks[publishID]
	if exists {
		delete(p.pendingAcks, publishID)
	}
	if err != nil && p.confirmErr == nil {
		p.confirmErr = err
	}
	p.confirmMu.Unlock()

	if exists {
		p.releaseConfirmationSlot()
		ackCh <- err
		close(ackCh)
	}
	p.notifyPendingZero()
}

func (p *RabbitMQStreamPublisher) failPendingConfirmations(err error) {
	p.confirmMu.Lock()
	if len(p.pendingAcks) == 0 {
		p.confirmMu.Unlock()
		return
	}
	if err != nil && p.confirmErr == nil {
		p.confirmErr = err
	}
	pending := p.pendingAcks
	p.pendingAcks = make(map[int64]chan error)
	p.confirmMu.Unlock()

	for _, ackCh := range pending {
		p.releaseConfirmationSlot()
		ackCh <- err
		close(ackCh)
	}
	p.notifyPendingZero()
}

func (p *RabbitMQStreamPublisher) acquireConfirmationSlot(ctx context.Context) error {
	if p.confirmSlots == nil {
		return nil
	}
	select {
	case p.confirmSlots <- struct{}{}:
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

func (p *RabbitMQStreamPublisher) releaseConfirmationSlot() {
	if p.confirmSlots == nil {
		return
	}
	select {
	case <-p.confirmSlots:
	default:
	}
}

func (p *RabbitMQStreamPublisher) waitForPendingConfirmations(timeout time.Duration) error {
	deadline := time.NewTimer(timeout)
	defer deadline.Stop()

	for {
		p.confirmMu.Lock()
		if p.confirmErr != nil {
			err := p.confirmErr
			p.confirmMu.Unlock()
			return err
		}
		if len(p.pendingAcks) == 0 {
			p.confirmMu.Unlock()
			return nil
		}
		pendingZero := p.pendingZero
		pendingCount := len(p.pendingAcks)
		p.confirmMu.Unlock()

		select {
		case <-pendingZero:
		case <-deadline.C:
			return fmt.Errorf("timed out waiting for %d pending publish confirmations on %q", pendingCount, p.streamName)
		}
	}
}

func (p *RabbitMQStreamPublisher) notifyPendingZero() {
	p.confirmMu.Lock()
	defer p.confirmMu.Unlock()
	if len(p.pendingAcks) == 0 && p.pendingZero != nil {
		select {
		case <-p.pendingZero:
		default:
			close(p.pendingZero)
		}
	}
}

func closedSignal() chan struct{} {
	ch := make(chan struct{})
	close(ch)
	return ch
}

func (p *RabbitMQStreamPublisher) trackClose(events stream.ChannelClose) {
	if events == nil {
		return
	}

	for event := range events {
		if event.Err == nil && event.Reason == stream.DeletePublisher {
			return
		}
		closeErr := event.Err
		if closeErr == nil {
			closeErr = fmt.Errorf("stream producer %q for %q closed: %s", event.Name, event.StreamName, event.Reason)
		} else {
			closeErr = fmt.Errorf("stream producer %q for %q closed: %w", event.Name, event.StreamName, event.Err)
		}
		p.failPendingConfirmations(closeErr)
		return
	}
}

func (c *RabbitMQStreamConsumer) handleMessage(consumerContext stream.ConsumerContext, message *streamamqp.Message) {
	body := message.GetData()
	if len(body) == 0 {
		c.publishError(fmt.Errorf("empty stream message from %q at offset %d", c.streamName, consumerContext.Consumer.GetOffset()))
		return
	}

	chunk := &pb.DataChunk{}
	if err := proto.Unmarshal(body, chunk); err != nil {
		c.publishError(fmt.Errorf("unmarshal delivery from %q at offset %d: %w", c.streamName, consumerContext.Consumer.GetOffset(), err))
		return
	}

	delivery := &RabbitMQStreamDelivery{
		chunk:    chunk,
		offset:   consumerContext.Consumer.GetOffset(),
		consumer: consumerContext.Consumer,
	}

	select {
	case <-c.closed:
		return
	case c.deliveries <- delivery:
	}
}

func (c *RabbitMQStreamConsumer) trackClose(events stream.ChannelClose) {
	if events == nil {
		return
	}

	select {
	case <-c.closed:
		return
	case event, ok := <-events:
		if !ok {
			return
		}
		if event.Err != nil {
			c.publishError(fmt.Errorf("stream consumer %q for %q closed: %w", c.consumerName, c.streamName, event.Err))
			return
		}
		c.publishError(fmt.Errorf("stream consumer %q for %q closed: %s", c.consumerName, c.streamName, event.Reason))
	}
}

func (c *RabbitMQStreamConsumer) publishError(err error) {
	if err == nil {
		return
	}
	select {
	case c.errs <- err:
	default:
	}
}

ARG GO_VERSION=1.24.0

FROM golang:${GO_VERSION}-bookworm AS builder
ARG SERVICE
WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN test -n "${SERVICE}"
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/app ./cmd/${SERVICE}

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /out/app /usr/local/bin/app
ENTRYPOINT ["/usr/local/bin/app"]

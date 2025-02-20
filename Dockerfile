FROM golang:alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

# Copy go.mod first
COPY go.mod ./

# Download dependencies
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build main.go specifically
RUN go build -o /go/bin/app main.go

FROM alpine:latest

RUN apk add --no-cache ca-certificates

COPY --from=builder /go/bin/app /app

EXPOSE 8080

ENTRYPOINT ["/app"]

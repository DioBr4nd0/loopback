.PHONY: run run-containers stop clean build test help run-proxy-server

# Default target
all: build

## build: builds the proxy server
build:
    @echo "Building proxy server..."
    @go build -o bin/proxy-server cmd/main.go

## run: starts demo http services and proxy server
run: run-containers run-proxy-server

## run-containers: starts demo backend servers in docker
run-containers:
    @echo "Starting demo servers..."
    @docker run --rm -d -p 9001:80 --name server1 kennethreitz/httpbin || true
    @docker run --rm -d -p 9002:80 --name server2 kennethreitz/httpbin || true
    @docker run --rm -d -p 9003:80 --name server3 kennethreitz/httpbin || true
    @echo "Demo servers started successfully"

## stop: stops all running containers
stop:
    @echo "Stopping containers..."
    @docker stop server1 server2 server3 2>/dev/null || true
    @echo "Containers stopped"

## clean: removes binary files
clean:
    @echo "Cleaning up..."
    @rm -rf bin/
    @echo "Clean complete"

## test: run tests
test:
    @echo "Running tests..."
    @go test ./... -v

## run-proxy-server: starts the proxy server
run-proxy-server:
    @echo "Starting proxy server..."
    @go run cmd/main.go

## help: show this help message
help:
    @echo 'Usage:'
    @echo
    @echo 'Available commands:'
    @sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

.DEFAULT_GOAL := help
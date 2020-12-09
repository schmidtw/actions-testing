.PHONY: default build test docker deps


DOCKER       ?= docker
GO           ?= go
GOFMT        ?= $(GO)fmt
APP          := actions-testing
DOCKER_ORG   := xmidt

VERSION ?= $(shell git describe --tag --always --dirty)
PROGVER ?= $(shell git describe --tags `git rev-list --tags --max-count=1` | tail -1 | sed 's/v\(.*\)/\1/')
BUILDTIME = $(shell date -u '+%Y-%m-%d %H:%M:%S')
GITCOMMIT = $(shell git rev-parse --short HEAD)
GOBUILDFLAGS = -a -ldflags "-w -s -X 'main.BuildTime=$(BUILDTIME)' -X main.GitCommit=$(GITCOMMIT) -X main.Version=$(VERSION)" -o $(APP)

default: build


generate:
	$(GO) generate ./...
	$(GO) install ./...

test:  generate
	go get github.com/ory/go-acc
	CGO_ENABLED=0 go-acc ./... -o coverage.out

check:
	golangci-lint run -n | tee errors.txt

build:  generate
	CGO_ENABLED=0 $(GO) build $(GOBUILDFLAGS)

release: generate build
	upx $(APP)

docker:
	-$(DOCKER) rmi "$(APP):$(VERSION)"
	-$(DOCKER) rmi "$(BIN):latest"
	$(DOCKER) build -t "$(APP):$(VERSION)" -t "$(APP):latest" .
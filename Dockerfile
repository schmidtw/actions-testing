FROM docker.io/library/golang:1.15-alpine as builder
LABEL maintainer="Jack Murdock <jack_murdock@comcast.com>"

WORKDIR /go/src/github.com/xmidt-org/actions-testing

ARG VERSION
ARG GITCOMMIT
ARG BUILDTIME

RUN apk add --no-cache --no-progress \
    ca-certificates \
    make \
    git \
    openssh \
    gcc \
    libc-dev \
    upx

COPY . .
RUN make build

FROM alpine:latest

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/github.com/xmidt-org/actions-testing/actions-testing /actions-testing
COPY --from=builder /go/src/github.com/xmidt-org/actions-testing/Dockerfile /go/src/github.com/xmidt-org/actions-testing/NOTICE /go/src/github.com/xmidt-org/actions-testing/LICENSE /go/src/github.com/xmidt-org/actions-testing/CHANGELOG.md /

USER nobody


EXPOSE 8080

CMD ["/actions-testing"]
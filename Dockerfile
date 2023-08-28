FROM debian:12 as builder
ARG TARGETARCH
RUN apt-get update && apt-get install -y curl clang gcc llvm make libbpf-dev -y
RUN curl -LO https://go.dev/dl/go1.20.linux-${TARGETARCH}.tar.gz && tar -C /usr/local -xzf go*.linux-${TARGETARCH}.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
WORKDIR /app
COPY . .
RUN make build

FROM gcr.io/distroless/base-debian12@sha256:c7bc12a0d98616d80a82e3557de99880d9b6b10a31e281e5174709c95609ae79
COPY --from=builder /app/otel-go-instrumentation /
CMD ["/otel-go-instrumentation"]

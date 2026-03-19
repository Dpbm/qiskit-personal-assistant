# ---- FETCH FROM GIT -------
FROM alpine:3.23.3 AS downloader
RUN apk add --no-cache git
WORKDIR /repo
RUN git clone https://github.com/zeroclaw-labs/zeroclaw.git


# ---- BUILD DASHBOARD -------
FROM node:24.14.0-bullseye-slim AS web-builder
WORKDIR /app
COPY --from=downloader /repo/zeroclaw/web .

ENV CI=true
ENV NODE_OPTIONS="--max-old-space-size=2048"
ENV PATH="/app/node_modules/.bin:$PATH"
ENV ESBUILD_WORKER_THREADS=1
ENV NODE_ENV=development

RUN npm ci 
RUN tsc -b --clean 
RUN tsc -b --verbose --pretty false 
RUN vite build --mode production --debug

# ---- BUILD -------
FROM rust:1.94.0-slim-bullseye AS builder
WORKDIR /app

COPY --from=downloader /repo/zeroclaw/src src/
COPY --from=downloader /repo/zeroclaw/Cargo.toml .
COPY --from=downloader /repo/zeroclaw/Cargo.lock .

RUN sed -i 's/members = \[".", "crates\/robot-kit"\]/members = ["."]/' Cargo.toml
RUN mkdir -p ./benches && echo "fn main() {}" > benches/agent_benchmarks.rs

COPY --from=web-builder /app/dist web/dist

RUN apt update && apt install git musl-tools pkg-config -y
RUN rustup target add x86_64-unknown-linux-musl && \
    cargo build --release --target x86_64-unknown-linux-musl

# ---- FOR DEBUG -------
FROM busybox:1.37.0-musl AS tools

# ---- EXPOSE -------
FROM scratch
WORKDIR /
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/zeroclaw /bin/zeroclaw
COPY --from=tools /bin/busybox /bin/busybox

ENV LANG=C.UTF-8
ENV HOME=/
ENV ZEROCLAW_GATEWAY_PORT=42617

RUN ["/bin/busybox", "--install", "-s", "/bin"]

HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=10s \
    CMD ["/bin/zeroclaw", "status", "--format=exit-code"]

EXPOSE 42617

ENTRYPOINT ["/bin/zeroclaw"]
CMD ["daemon", "--config-dir", "/.zeroclaw/"]


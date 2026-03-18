FROM rust:1.94.0-slim-bullseye AS build
WORKDIR /
RUN apt update && apt install git musl-tools -y
RUN git clone https://github.com/zeroclaw-labs/zeroclaw.git
RUN cd zeroclaw && \ 
    rustup target add x86_64-unknown-linux-musl && \
    cargo build --release --locked --target x86_64-unknown-linux-musl

FROM scratch
WORKDIR /
COPY --from=build /zeroclaw/target/x86_64-unknown-linux-musl/release/zeroclaw /bin/zeroclaw

EXPOSE 42617
CMD ["/bin/zeroclaw", "gateway"]


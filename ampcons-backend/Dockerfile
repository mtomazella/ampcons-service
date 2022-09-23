FROM rust

WORKDIR /usr/src/ampcons
COPY . .

RUN cargo install --path .
RUN cargo build

CMD ["cargo", "run"]
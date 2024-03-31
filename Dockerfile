# syntax=docker/dockerfile:1.6

FROM tinygo/tinygo:latest AS builder

WORKDIR /app
COPY . /app
RUN go get -u ./...
RUN tinygo build -o /app/greeter-func.wasm -target wasi main.go

FROM wasmedge/slim-runtime:0.13.5

COPY --from=builder /app/greeter-func.wasm .

EXPOSE 8090
ENTRYPOINT ["wasmedge", "./greeter-func.wasm"]

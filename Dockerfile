# syntax=docker/dockerfile:1.6

#FROM tinygo/tinygo:latest AS goBuilder
FROM golang:latest AS goBuilder

WORKDIR /app
COPY . /app
RUN go get -u ./...
#RUN tinygo build -o /app/server.wasm -target wasi main.go
RUN GOARCH=wasm GOOS=wasip1 go build -o server.wasm main.go

FROM wasmedge/slim:0.13.5 AS wasmBuilder

COPY --from=goBuilder /app/server.wasm .
CMD ["wasmedge", "compile", "server.wasm", "server.wasm"]


FROM wasmedge/slim-runtime:0.13.5

# /app is the default workdir on wasmedge/slim
COPY --from=wasmBuilder /app/server.wasm .
EXPOSE 3000
ENTRYPOINT ["wasmedge", "./server.wasm"]
package main

import (
	"github.com/stealthrocket/net/wasip1"
	"net/http"
)

func main() {
	listener, err := wasip1.Listen("tcp", ":3000")
	if err != nil {
		panic(err)
	}

	server := &http.Server{
		Handler: http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			w.Write([]byte("Hello, World!"))
			w.WriteHeader(http.StatusOK)
		}),
	}

	if err := server.Serve(listener); err != nil {
		panic(err)
	}
}

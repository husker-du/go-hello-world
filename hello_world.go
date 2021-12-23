package main

import (
	"fmt"
	"os"
	"time"
	"net/http"
)

const (
	port = "80"
)

func HelloWorld(w http.ResponseWriter, r *http.Request) {
	hostname, error := os.Hostname()
	if error != nil {
  	hostname = "unknown"
 	}
	fmt.Fprintf(w, "Hello world from [ %s ]", hostname)
	time.Sleep(1 * time.Second)
}

func HealthCheck(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "I'm running")
}

func main() {
	fmt.Printf("Starting server... at http://localhost:%v.\n", port)
	http.HandleFunc("/", HelloWorld)
	http.HandleFunc("/health", HealthCheck)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		fmt.Println("Error: " + err.Error())
	}
	fmt.Println("Program exit")
}

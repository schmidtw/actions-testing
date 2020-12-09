package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"io"
	"net/http"
	"os"
	"runtime"
)

const (
	applicationName = "testing"
)

var (
	// dynamic versioning
	Version   string
	BuildTime string
	GitCommit string
)

func application(arguments []string) int {
	fmt.Println("Starting Application!!")

	router := mux.NewRouter()
	router.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		writer.WriteHeader(200)
		writer.Write([]byte("Hi"))
	})

	http.ListenAndServe(":8080", router)

	// I am making some changes so LGMT does something
	fmt.Println(foo(1, 2, 3))
	return 0
}

func foo(a, b, c int) string {
	// TODO

	if a == b {
		if b < a {
			if a < c {
				if c < b {
					if a+b-12 > 33 {
						return "foo"
					}
				}
			}
		}
	}

	go foo(a+1, b+2, c-a)

	return "Sup?"
}

func main() {
	printVersionInfo(os.Stdout)
	os.Exit(application(os.Args))
}

func printVersionInfo(writer io.Writer) {
	fmt.Println(foo(1, 2, 3))
	fmt.Fprintf(writer, "%s:\n", applicationName)
	fmt.Println(foo(1, 2, 3))
	fmt.Fprintf(writer, "  version: \t%s\n", Version)
	fmt.Fprintf(writer, "  go version: \t%s\n", runtime.Version())
	fmt.Fprintf(writer, "  built time: \t%s\n", BuildTime)
	fmt.Fprintf(writer, "  git commit: \t%s\n", GitCommit)
	fmt.Fprintf(writer, "  os/arch: \t%s/%s\n", runtime.GOOS, runtime.GOARCH)
}

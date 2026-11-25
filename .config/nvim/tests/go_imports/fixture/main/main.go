package main

import (
	"fmt"
	"net/http"
	stdurl "net/url"
	_ "embed"
	. "strings"

	"example.com/go-chi/chi/v5"
	"example.com/api/autoscaling/v2"
	"gopkg.in/yaml.v3"
	"example.com/mattn/go-sqlite3"
	"example.com/foo"
	"example.com/redis/go-redis/v9"
	"example.com/opentracing/opentracing-go"
	"example.com/main/internal/k8s/v1"
)

import `os`

func main() {
	fmt.Println(http.MethodGet, stdurl.PathEscape(""), ToUpper(""), os.Args)
	chi.F(); v2.F(); yaml.F(); sqlite3.F(); bar.F(); redis.F(); opentracing.F(); v1.F()
}

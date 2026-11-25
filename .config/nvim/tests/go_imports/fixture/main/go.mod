module example.com/main

go 1.25

require (
	example.com/go-chi/chi/v5 v5.0.0
	example.com/api/autoscaling/v2 v2.0.0
	gopkg.in/yaml.v3 v3.0.0
	example.com/mattn/go-sqlite3 v1.0.0
	example.com/foo v1.0.0
	example.com/redis/go-redis/v9 v9.0.0
	example.com/opentracing/opentracing-go v1.0.0
)

replace (
	example.com/go-chi/chi/v5 => ../deps/chi
	example.com/api/autoscaling/v2 => ../deps/autoscaling
	gopkg.in/yaml.v3 => ../deps/yaml
	example.com/mattn/go-sqlite3 => ../deps/sqlite3
	example.com/foo => ../deps/foo
	example.com/redis/go-redis/v9 => ../deps/redis
	example.com/opentracing/opentracing-go => ../deps/opentracing
)

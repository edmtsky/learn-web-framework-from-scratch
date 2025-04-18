# Plug.Webfw.HttpServer

This is a sample study project to check out the webfw_http_server package
configured to work with the [Plug](https://hexdocs.pm/plug/readme.html) library

t1:
```sh
iex -S mix
```
```elixir
iex> Code.require_file("./temp/example_router.ex")
iex> options = {Plug.Webfw.HttpServer, [plug: ExampleRouter, options: []]}
iex> Application.put_env(:webfw_http_server, :dispatcher, options)
iex> Webfw.HttpServer.start(4040)

10:46:42.592 [info] Started a webserver on port 4040
```

t2:
```sh
curl http://localhost:4040/greet
Hello World
```

t1:
```sh
10:46:48.685 [info] Received HTTP request GET at /greet
```

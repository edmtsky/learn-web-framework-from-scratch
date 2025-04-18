# Plug.Webfw.HttpServer

This is a sample study project to check out the webfw_http_server package
configured to work with the [Plug](https://hexdocs.pm/plug/readme.html) library

> how to check out it manually
(this steps will spin up the http server with routes defined in the given
external ex file)

```sh
iex -S mix
```
```elixir
iex> Code.require_file("./temp/example_router.ex")
iex> opts = [plug: ExampleRouter, port: 4040, options: []]
iex> %{start: {mod, fun, args}} = Plug.Webfw.HttpServer.child_spec(opts)
iex> apply(mod, fun, args)
{:ok, #PID<0.232.0>}

22:42:49.877 [info]  Started a webserver on port 4040
```

> alternative way without a `Plug.Webfw.HttpServer.child_spec`:

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


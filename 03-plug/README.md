
## Plug (from official documentation)

Plug is:

- A specification for composing web applications with functions
- Connection adapters for different web servers in the Erlang VM

In other words, Plug allows you to build web applications from small pieces and
run them on different web servers. Plug is used by web frameworks such as
Phoenix to manage requests, responses, and websockets. This documentation will
show some high-level examples and introduce the Plug's main building blocks.

... See [doc](https://hexdocs.pm/plug/readme.html)


- example_plug.exs - example of how to use Plug library with Cowboy http server.
- example_route.exs - example of how to use Plug.Route with Cowboy http server.


### example_plug.exs

t1: lauch http server on 4040 port for 10 seconds
```sh
elixir example_plug.exs
```

t2: check connection with server
```sh
wget -qO- http://localhost:4000
```

```sh
curl http://localhost:4040/greet
Hello World
```


### example_route.exs

```sh
elixir example_route.exs
```

t2: check connection with server
```sh
curl http://localhost:4040/greet
Hello World
```

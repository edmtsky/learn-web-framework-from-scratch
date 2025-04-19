# Webfw

This is a Webfw - my own learning implementation of Phoenix-like web-framework

- lib/webfw/controller.ex - is a Controller for my own web-framework
- lib/support/example-*.ex - sample web-app to check out impl of webfw


## Step 1: write own controller

write the web app and my own impl of the controller using the `Plug` package


Here are examples of how to reproduce and check the work of new introduced
features yourself.

The approach here is as follows:
- First, we get acquainted as it works in `plug_cowboy` package and
  check the work of new studied things added to our sample WebApp based on
  plug_cowboy
- Then try the same on the basis of my own implementations
  (webfw + plug_webfw_http_server)


## Controller - is an example of how to use:
  - first use of the plug


Deps:

mix.exs
```elixir
  defp deps do
    [
      {:plug, "~> 1.17"},
      {:jason, "~> 1.4"},
      # for WebApp.run_with_plug_cowboy
      {:plug_cowboy, "~> 2.7"}, # for a manual check out
      # for WebApp.run_with_own_impl
      {:plug_webfw_http_server, path: "../plug_webfw_http_server"}
    ]
  end
```


## Verify the work of plug_cowboy + my own Webfw.Controller

check out the plug with the own Webfw.Controller (manually via iex)

```sh
iex -S mix
```

run in iex session:
```elixir
iex> WebApp.run_with_plug_cowboy()
```
output:
```elixir
# apply(mod, fun, args)
{:ok, #PID<0.336.0>}        # this means that http server is started and listen
```

next send the request to setuped webapp:

```sh
curl -si http://localhost:4040/greet
```
```
HTTP/1.1 200 OK
cache-control: max-age=0, private, must-revalidate
content-length: 15
content-type: application/json; charset=utf-8
date: Sat, 19 Apr 2025 07:08:40 GMT
server: Cowboy

{"status":"ok"}
```
curl opts:
- `-s` means quiet mode
- `-i` - add response headers
`-s -i` can be replaced by `-v`

> notice:
- status-code: 200
- application/json
- `{"status":"ok"}`

An additional example of how to stop the WebApp(plug+cowboy) right on the go
without restarting iex:
```elixir
# ...
# iex> apply(mod, fun, args)
# {:ok, #PID<0.336.0>}

iex> {:ok, pid} = v()
# {:ok, #PID<0.336.0>}

iex> Process.exit(pid, :kill)
#** (EXIT from #PID<0.322.0>) shell process exited with reason: killed
#...
# 14:20:49.219 [error] GenServer #PID<0.338.0> terminating
#** (stop) killed
```

or just:
Ctrl-C + `iex -S mix`



## Verify the work of my own plug_webfw_http_server (insted of plug_cowboy)


test with `plug_webfw_http_server` to ensure our controller works with
our own HTTP server:


iex:
(run http server)
```elixir
iex> WebApp.run_with_own_impl()

# output:
# 10:13:45.765 [info] Started a webserver on port 4040
# {:ok, #PID<0.276.0>}
```
next

```sh
curl -s -i http://localhost:4040/greet
```
```
HTTP/1.1 200
cache-control: max-age=0, private, must-revalidate
content-length: 15
content-type: application/json; charset=utf-8

{"status":"ok"}
```


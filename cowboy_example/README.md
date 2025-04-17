# CowboyExample

Below are described steps to repeat this example from scratch

Create new project

```sh
mix new cowboy_example --sup
```

add Cowboy as a dependency to the project

mix.exs
```elixir
defmodule CowboyExample.MixProject do
  # ...
  defp deps do
    [
      {:cowboy, "~> 2.13"} # see https://hex.pm/packages/cowboy
    ]
  end
end
```

Pulling up dependencies

```sh
mix deps.get
```
output:
```
Resolving Hex dependencies...
Resolution completed in 0.231s
New:
  cowboy 2.13.0
  cowlib 2.15.0
  ranch 2.2.0
* Getting cowboy (Hex package)
* Getting cowlib (Hex package)
* Getting ranch (Hex package)
```


Adding a handler which listen a given port

./lib/cowboy_example/server.ex
```elixir
defmodule CowboyExample.Server do

  def start(port) do
    routes = CowboyExample.Router.routes()

    dispatch_rules =
      :cowboy_router.compile(routes)

    {:ok, _pid} =
      :cowboy.start_clear(
        :listener,
        [{:port, port}],
        %{env: %{dispatch: dispatch_rules}}
      )
  end
end
```

./lib/cowboy_example/router.ex
```elixir
defmodule CowboyExample.Router do
  require Logger

  def routes() do
    [
      # For now, this module itself will handle root requests
      {:_, [{"/", __MODULE__, []}]}
    ] #              ^(1)
  end

  #     v(1)
  def init(req0, state) do
    Logger.info("Received request: #{inspect req0}")
    req1 =
      :cowboy_req.reply(
        200,
        %{"content-type" => "text/html"},
        "Hello World\n",
        req0
      )
    {:ok, req1, state}
  end
end
```

add new children(worker) for application supervisor tree
(with hardcoded port)

```elixir
defmodule CowboyExample.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task, fn -> CowboyExample.Server.start(4040) end}   # (++ add this line)
    ]

    opts = [
      strategy: :one_for_one,
      name: CowboyExample.Supervisor
    ]
    Supervisor.start_link(children, opts)
  end
end
```

run web application:

```sh
mix run --no-halt
```

trigger client connection via curl:
```sh
curl -v http://localhost:4040/
```
output:
```
*   Trying ::1:4040...
* connect to ::1 port 4040 failed: Connection refused
*   Trying 127.0.0.1:4040...
* Connected to localhost (127.0.0.1) port 4040 (#0)
> GET / HTTP/1.1
> Host: localhost:4040
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< content-length: 12
< content-type: text/html
< date: Thu, 17 Apr 2025 08:25:33 GMT
< server: Cowboy
<
Hello World
* Connection #0 to host localhost left intact
```

output in the terminal with the server when the client sent the request:
```
11:25:34.018 [info] Received request: %{
  pid: #PID<0.220.0>,
  port: 4040,
  scheme: "http",
  version: :"HTTP/1.1",
  path: "/",
  host: "localhost",
  peer: {{127, 0, 0, 1}, 38990},
  bindings: %{},
  ref: :listener,
  cert: :undefined,
  headers: %{
    "accept" => "*/*",
    "host" => "localhost:4040",
    "user-agent" => "curl/7.74.0"
  },
  host_info: :undefined,
  path_info: :undefined,
  streamid: 1,
  method: "GET",
  body_length: 0,
  has_body: false,
  qs: "",
  sock: {{127, 0, 0, 1}, 4040}
}
```


#### Adding routes with bindings

move handler from router.ex to its own module:
create sub package router/handlers/

```elixir
defmodule CowboyExample.Router do
  alias CowboyExample.Router.Handlers.{Root, Greet} # +

  @doc """
  Returns the list of routes configured by this web server
  """
  def routes() do
    [
      {:_, [
        {"/", Root, []},
        {"/greet/:who", [who: :nonempty], Greet, []}      # << new route
      ]},
    ]
  end

  # move handler to its own separated module
end
```

./lib/cowboy_example/router/handlers/root.ex
```elixir
defmodule CowboyExample.Router.Handlers.Root do
  require Logger

  def init(req0, state) do
    Logger.info("Received request: #{inspect req0}")
    req1 =
      :cowboy_req.reply(
        200,
        %{"content-type" => "text/html"},
        "Hello World\n",
        req0
      )
    {:ok, req1, state}
  end
end
```

cowboy_example/lib/cowboy_example/router/handlers/greet.ex
```elixir
defmodule CowboyExample.Router.Handlers.Greet do
  require Logger

  def init(req0, state) do
    Logger.info("Received request: #{inspect req0}")
    who = :cowboy_req.binding(:who, req0)
    req1 =
      :cowboy_req.reply(
        200,
        %{"content-type" => "text/html"},
        "Hello #{who}\n",
        req0
      )
    {:ok, req1, state}
  end
end
```

next, restrat server with Ctrl-C + `mix run --no-halt`

```sh
curl http://localhost:4040/greet/Elixir
Hello Elixir
```


### add query parameters
```elixir
defmodule CowboyExample.Router.Handlers.Greet do
  # ...

  def init(req0, state) do
    Logger.info("Received request: #{inspect req0}")
    who = :cowboy_req.binding(:who, req0)

    greeting =                          # << from query parameters
      req0
      |> :cowboy_req.parse_qs()
      |> Enum.into(%{})
      |> Map.get("greeting", @default_greeting)

    req1 =
      :cowboy_req.reply(
        200,
        %{"content-type" => "text/html"},
        "#{greeting} #{who}\n",
        req0
      )

    {:ok, req1, state}
  end
 end
```

```sh
curl http://localhost:4040/greet/Elixir\?greeting=Hi
Hi Elixir
```


This implementation will work with any HTTP method(GET|POST):

```sh
curl -X POST http://localhost:4040/
Hello World
```



### validate HTTP methods (allow only GET)

```elixir
defmodule CowboyExample.Router.Handlers.Greet do
  # ..
  def init(%{method: "GET"} = req0, state) do
  # ..
  end

  # General clause for init/2 which responds with 404
  def init(req0, state) do
    Logger.info("Received request: #{inspect req0}")
    req1 =
      :cowboy_req.reply(
        404,
        %{"content-type" => "text/html"},
        "404 Not found\n",
        req0
      )
    {:ok, req1, state}
  end
end

```
```sh
curl http://localhost:4040/greet/Elixir\?greeting=Hi
Hi Elixir
```

POST request give 404 error:

```sh
curl http://localhost:4040/greet/Elixir\?greeting=Hi -X POST
404 Not found
```


### Serve static HTML files

create static index.html file to serve:
```sh
mkdir -p priv/static/ && echo "<h1>Hello World</h1>" > priv/static/index.html
```

add new module, which can read static file from priv/static directory:

add ./lib/cowboy_example/router/handlers/static.ex

check manualy:
run web-server
```sh
mix run --no-halt
```

send client requests to static files:
```sh
curl http://localhost:4040/static/index.html
<h1>Hello World</h1>
```

fail case:
```sh
curl http://localhost:4040/static/bad.html
404 Not found
```



### Testing the web server with ExUnit

make server port configurable


./lib/cowboy_example/application.ex
```elixir
defmodule CowboyExample.Application do
  @moduledoc false

  use Application

  @port Application.compile_env(:cowboy_example, :port, 4040) # <<< +++

  @impl true
  def start(_type, _args) do
    children = [
      {Task, fn -> CowboyExample.Server.start(@port) end} # << Update this line
    ]
    # ...
  end
end
```

```sh
mkdir config && touch config/config.exs
```

```elixir
import Config

if Mix.env() == :test do
  config :cowboy_example, port: 4041

  config :logger, warn: false
end
```

add a Finch - high-performance HTTP client as dependency:

```sh
defp deps do
[
  {:finch, "~> 0.6"},
  # ...
]
```

```sh
mix deps.get
```

```
Resolving Hex dependencies...
Resolution completed in 5.558s
New:
  finch 0.19.0
  hpax 1.0.3
  mime 2.0.6
  mint 1.7.1
  nimble_options 1.1.1
  nimble_pool 1.1.0
  telemetry 1.3.0
Unchanged:
  cowboy 2.13.0
  cowlib 2.15.0
  ranch 2.2.0
* Getting finch (Hex package)
* Getting mime (Hex package)
* Getting mint (Hex package)
* Getting nimble_options (Hex package)
* Getting nimble_pool (Hex package)
* Getting telemetry (Hex package)
* Getting hpax (Hex package)
```

add first test test/cowboy_example/server_test.exs

```sh
mix test
Running ExUnit with seed: 671048, max_cases: 8

...
13:31:00.865 [info] Received request: %{pid: #PID<0.278.0>, port: 4041, scheme: "http", version: :"HTTP/1.1", path: "/static/index.html", host: "localhost", peer: {{127, 0, 0, 1}, 60052}, bindings: %{page: "index.html"}, ref: :listener, cert: :undefined, headers: %{"host" => "localhost:4041", "user-agent" => "mint/1.7.1"}, host_info: :undefined, path_info: :undefined, method: "GET", streamid: 2, body_length: 0, has_body: false, qs: "", sock: {{127, 0, 0, 1}, 4041}}
.
13:31:00.867 [info] Received request: %{pid: #PID<0.278.0>, port: 4041, scheme: "http", version: :"HTTP/1.1", path: "/greet/Elixir", host: "localhost", peer: {{127, 0, 0, 1}, 60052}, bindings: %{who: "Elixir"}, ref: :listener, cert: :undefined, headers: %{"host" => "localhost:4041", "user-agent" => "mint/1.7.1"}, host_info: :undefined, path_info: :undefined, method: "GET", streamid: 3, body_length: 0, has_body: false, qs: "", sock: {{127, 0, 0, 1}, 4041}}
.
13:31:00.869 [info] Received request: %{pid: #PID<0.278.0>, port: 4041, scheme: "http", version: :"HTTP/1.1", path: "/greet/Elixir", host: "localhost", peer: {{127, 0, 0, 1}, 60052}, bindings: %{who: "Elixir"}, ref: :listener, cert: :undefined, headers: %{"host" => "localhost:4041", "user-agent" => "mint/1.7.1"}, host_info: :undefined, path_info: :undefined, method: "GET", streamid: 4, body_length: 0, has_body: false, qs: "greeting=Hi", sock: {{127, 0, 0, 1}, 4041}}
.
13:31:00.871 [info] Received request: %{pid: #PID<0.278.0>, port: 4041, scheme: "http", version: :"HTTP/1.1", path: "/", host: "localhost", peer: {{127, 0, 0, 1}, 60052}, bindings: %{}, ref: :listener, cert: :undefined, headers: %{"host" => "localhost:4041", "user-agent" => "mint/1.7.1"}, host_info: :undefined, path_info: :undefined, method: "GET", streamid: 5, body_length: 0, has_body: false, qs: "", sock: {{127, 0, 0, 1}, 4041}}
.
Finished in 0.1 seconds (0.00s async, 0.1s sync)
1 doctest, 6 tests, 0 failures
```


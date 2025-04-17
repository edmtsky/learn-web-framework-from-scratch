# Experemental Server


## Step 1 - Listening over a TCP socket using :gen_tcp

This is the simplest TCP-socket-server that can accept incoming connections
without responding to them and keep the connection alive, reciving data from
the client.

start the tcp-socket-server in first terminal:
```sh
elixir experiment_server.exs
Listening on port 4040
```

in the second terminal:
```sh
curl -v http://localhost:4040/

*   Trying ::1:4040...
* connect to ::1 port 4040 failed: Connection refused
*   Trying 127.0.0.1:4040...
* Connected to localhost (127.0.0.1) port 4040 (#0)
> GET / HTTP/1.1
> Host: localhost:4040
> User-Agent: curl/7.74.0
> Accept: */*
>
```

1th term(tcp-serv):

```sh
Got message: {:http_request, :GET, {:abs_path, "/"}, {1, 1}}

Got message: {:http_header, 14, :Host, "Host", "localhost:4040"}

Got message: {:http_header, 24, :"User-Agent", "User-Agent", "curl/7.74.0"}

Got message: {:http_header, 8, :Accept, "Accept", "*/*"}

Got message: :http_eoh
```

2th term(curl-client):
Ctrl-C

1th term(serv):
```sh
Socket closed
Messages:
[
  :http_eoh,
  {:http_header, 8, :Accept, "Accept", "*/*"},
  {:http_header, 24, :"User-Agent", "User-Agent", "curl/7.74.0"},
  {:http_header, 14, :Host, "Host", "localhost:4040"},
  {:http_request, :GET, {:abs_path, "/"}, {1, 1}}
]
```


### Step 2 - Responding over a TCP socket using :gen_tcp

```elixir
defmodule ExperimentalServer do
  require Logger

  def start(port) do
    listener_options = [active: false, packet: :http_bin, reuseaddr: true]

    {:ok, listen_socket} = :gen_tcp.listen(port, listener_options)

    IO.puts("Listening on port #{port}")
    listen(listen_socket)
    :gen_tcp.close(listen_socket) # :ok
  end

  defp listen(listen_socket) do
    {:ok, connection_sock} = :gen_tcp.accept(listen_socket)
    {:ok, req} = :gen_tcp.recv(connection_sock, 0)

    Logger.info("Got request: #{inspect req}")
    respond(connection_sock)
    listen(listen_socket)
  end

  defp respond(connection_sock) do
    :gen_tcp.send(connection_sock, "Response from the Server\n")

    Logger.info("Sent response")

    :gen_tcp.close(connection_sock)
  end
end

ExperimentalServer.start(4040)
```

check out:

t1:
```sh
make run
elixir experiment_server.exs
Listening on port 4040
```

t2:
```sh
curl http://localhost:4040/
curl: (1) Received HTTP/0.9 when not allowed
```

t1:
```sh
16:03:48.806 [info] Got request: {:http_request, :GET, {:abs_path, "/"}, {1, 1}}

16:03:48.810 [info] Sent response
```

So, by default, send/2 sends an HTTP/0.9 response.

to fix that, and use http/1.1:

```elixir
defmodule ExperimentServer do
  # ..

  defp respond(connection_sock) do
    # Send a proper HTTP/1.1 response with status
    response = http_1_1_response("Response from the Server\n", 200)
    :gen_tcp.send(connection_sock, response)
    Logger.info("Sent response")

    :gen_tcp.close(connection_sock)
  end

  # Converts a body to HTTP/1.1 response string
  defp http_1_1_response(body, status) do
    """
    HTTP/1.1 #{status}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(body)}\r
    \r
    #{body}
    """
  end
end
```

Now its works with curl:
```sh
curl http://localhost:4040/

Response from the Server
```


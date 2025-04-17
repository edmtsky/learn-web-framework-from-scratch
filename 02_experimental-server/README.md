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

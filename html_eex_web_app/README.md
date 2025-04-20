# HtmlEexWebApp

this is a Sample WebApp what can responding with embedded Elixir with
own HTTP server worked with Webfw (own impl of Phoenix-like web-framework).

it was created via:
```sh
mix new example_html_eex_server_html
```


how to run WebApp:

```sh
iex -S mix

iex> HtmlEexWebApp.run_with_plug_cowboy()
```
how to check:

t2:
```sh
curl -si  http://localhost:4040/greet?greeting=Hi
```
```
HTTP/1.1 200 OK
cache-control: max-age=0, private, must-revalidate
content-length: 21
content-type: text/html; charset=utf-8
server: Cowboy

<h1>Hi World</h1>
```

```sh
curl -si  http://localhost:4040/greet
```
```
HTTP/1.1 400 Bad Request
cache-control: max-age=0, private, must-revalidate
content-length: 21
server: Cowboy

<h1>Bad Request</h1>
```

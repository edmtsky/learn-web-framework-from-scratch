## webfw

webfw - this is a learning project in order to understand how to write
web frameworks from scratch.

- webfw_http_server - my own server for use instead of Cowboy (for study purpose)
- plug_webfw_http_server - analogue of plug_cowboy
- webfw - my own implementation of Phoenix-like web framework from scratch
  - lib/support - a sample webapp what uses webfw and plug_webfw_http_server




to use this library as dependency you should add this to your config file:

config/config.exs
```elixir
import Config

config :webfw_http_server, responder: YourWebApp.Responder
```


plug_webfw_http_server - example how to use own http server with a Plug library,
and a package to be used in the sample WebApp (inside the webfw)

```sh
mix new plug_webfw_http_server --module Plug.Webfw.HttpServer
```


Create the package for the own Web-framework

```sh
mix new webfw
```

- ./webfw/lib/support/   - the sample app with Router defined via `Plug` library
   - example_controller.ex
   - example_router.ex

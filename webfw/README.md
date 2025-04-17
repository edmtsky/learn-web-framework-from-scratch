## webfw

webfw - this is a learning project in order to understand how to write
web frameworks from scratch.

- webfw_http_server - my own server for use instead of Cowboy (for study purpose)



```sh
mix new webfw
```


to use this library as dependency you should add this to your config file:

config/config.exs
```elixir
import Config

config :webfw_http_server, responder: YourWebApp.Responder
```



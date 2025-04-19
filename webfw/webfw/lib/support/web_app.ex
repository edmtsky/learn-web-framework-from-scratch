defmodule WebApp do
  @moduledoc """
  Something like a web-app launcher based on the sources in this directory

  Designed for use inside the console: iex -S mix

  Code.require_file("./lib/support/web_app.ex")
  WebApp.run_with_own_impl()

  works based on :plug_webfw_http_server package - the own study implementation
  (replacement for :plug_cowboy)
  """
  def run_with_own_impl() do
    # Code.require_file("./lib/support/example_controller.ex")
    # Code.require_file("./lib/support/example_router.ex")
    opts = [plug: Webfw.ExampleRouter, port: 4040, options: []]

    # Here is the choice of the option through what to launch a web application
    %{start: {mod, fun, args}} = Plug.Webfw.HttpServer.child_spec(opts)

    apply(mod, fun, args)
  end

  @doc """
  works based on :plug_cowboy (Plug configured to work via http-web-server)
  """
  def run_with_plug_cowboy() do
    # Code.require_file("./lib/support/example_controller.ex")
    # Code.require_file("./lib/support/example_router.ex")
    # Mix.install([{:plug_cowboy, "~> 2.0"}])
    opts = [scheme: :http, plug: Webfw.ExampleRouter, options: [port: 4040]]

    %{start: {mod, fun, args}} = Plug.Cowboy.child_spec(opts)

    apply(mod, fun, args)
  end
end

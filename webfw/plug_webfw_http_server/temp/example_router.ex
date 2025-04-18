defmodule ExampleRouter do
  @moduledoc """
  iex -S mix

  iex> Code.require_file("./temp/example_router.ex")
  iex> options = {Plug.Webfw.HttpServer, [plug: ExampleRouter, options: []]}
  iex> Application.put_env(:webfw_http_server, :dispatcher, options)
  iex> Webfw.HttpServer.start(4040)

  """
  use Plug.Router

  plug :match
  plug :dispatch

  get "/greet" do
    send_resp(conn, 200, "Hello World\n")
  end

  match _ do
    send_resp(conn, 404, "Not Found\n")
  end
end

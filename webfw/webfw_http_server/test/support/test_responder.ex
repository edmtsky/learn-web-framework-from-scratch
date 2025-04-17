defmodule Webfw.TestResponder do
  import Webfw.HttpServer.ResponderHelper

  @behaviour Webfw.HttpServer.Responder

  @impl true
  def resp(_req, method, path) do
    cond do
      method == :GET && path == "/hello" ->
        "Hello World\n"
        |> http_response()
        |> put_header("Content-type", "text/html")
        |> put_status(200)

      true ->
        "Not Found\n"
        |> http_response()
        |> put_header("Content-type", "text/html")
        |> put_status(404)
    end
  end
end

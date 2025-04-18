defmodule TestWebfwHttpServer.Responder do
  import Webfw.HttpServer.ResponderHelper

  def resp(_req, method, path) do
    cond do
      method == :GET && path == "/hello" ->
        http_response("Hello World\n")
        |> put_header("Content-type", "text/html")
        |> put_status(200)

      method == :GET && path == "/long-operation" ->
        # sleep for 5 seconds
        :timer.sleep(5000)
        http_response("Long Operation done\n")
        |> put_header("Content-type", "text/html")
        |> put_status(200)

      true ->
        http_response("Not Found\n")
        |> put_header("Content-type", "text/html")
        |> put_status(404)
    end
  end
end

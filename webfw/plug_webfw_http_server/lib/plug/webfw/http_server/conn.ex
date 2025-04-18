defmodule Plug.Webfw.HttpServer.Conn do
  import Webfw.HttpServer.ResponderHelper

  @moduledoc false
  @behaviour Plug.Conn.Adapter

  @impl true
  def send_resp({req, method, path}, status, headers, body) do
    resp_string =
      body
      |> http_response()
      |> apply_headers(headers)
      |> put_status(status)
      |> Webfw.HttpResponse.to_string()

    :gen_tcp.send(req, resp_string)

    :gen_tcp.close(req)

    {:ok, nil, {req, method, path}}
  end

  defp apply_headers(resp, headers) do
    Enum.reduce(headers, resp, fn {k, v}, resp ->
      put_header(resp, k, v)
    end)
  end


  # Plug.Conn.Adapter callbacks: chunk/2, get_http_protocol/1, get_peer_data/1
  # upgrade/3, send_file/6, send_chunked/3, read_req_body/2, inform/3
end

defmodule Webfw.Controller do
  @moduledoc """
  This is a module of a base implementation of the Controller in my own
  Web-Framework
  """
  import Plug.Conn

  def render(conn, :json, data) when is_map(data) do
    status = conn.status || 200

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end

end

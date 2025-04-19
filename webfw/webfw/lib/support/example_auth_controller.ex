defmodule WebApp.ExampleAuthController do
  @moduledoc """
  In this module defined the endpoing for /GET /check_auth via Plug.Builder,
  and pipeline of one plug :ensure_authorized.
  All actions(check_auth) in this conroller will pass through the
  ensure_authorized plug. and if the request connection without
  `Authorization Bearer: secret` the connection will be halted without calling
  actual action
  """
  use Plug.Builder # import Plug.Conn
  import Webfw.Controller

  plug :ensure_authorized!

  def call(conn, action: action) do
    conn = super(conn, []) # Plug.Builder.call/2

    unless conn.state == :sent or conn.halted do
      apply(__MODULE__, action, [conn, conn.params])
    else
      conn
    end
  end

  def check_auth(conn, _params) do
    conn
    |> put_status(200)
    |> render(:json, %{status: "ok"})
  end

  # ..

  defp ensure_authorized!(conn, _opts) do
    if authorized?(conn) do
      conn
    else
      conn
      |> put_status(401)
      |> render(:json, %{status: "Unauthorized"})
      |> halt()
    end
  end

  defp authorized?(conn) do
    auth_header = get_req_header(conn, "authorization")
    auth_header == ["Bearer #{token()}"]
  end

  defp token(), do: "secret"
end

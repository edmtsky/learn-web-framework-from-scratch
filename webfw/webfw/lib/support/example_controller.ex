defmodule WebApp.ExampleController do
  @moduledoc """
  this is a simple WebApp example of how to use plug with Webfw
  """
  import Plug.Conn
  # Webfw.Controller should define all the helper functions
  import Webfw.Controller

  def call(conn, action: action) do
    apply(__MODULE__, action, [conn, conn.params])
  end

  def greet(conn, _params) do
    conn
    |> put_status(200)
    |> render(:json, %{status: "ok"})
  end

  def redirect_greet(conn, _params) do
    conn
    |> redirect(to: "/greet")
  end

end

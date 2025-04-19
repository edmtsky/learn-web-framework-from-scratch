defmodule WebApp.ExampleFallback do
  import Plug.Conn
  import Webfw.Controller

  def call(conn, {:error, :bad_params}) do
    conn
    |> put_status(500)
    |> render(:json, %{error: "bad params"})
  end
end

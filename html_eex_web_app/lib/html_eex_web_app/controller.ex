defmodule HtmlEexWebApp.Controller do
  use Plug.Builder

  import Plug.Conn
  import Webfw.Controller

  def call(conn, action: action) do
    conn = super(conn, [])

    apply(__MODULE__, action, [conn, conn.params])
  end

  def greet(conn, _params) do
    conn
    |> put_status(200)
    |> render(:html, "<h1>Hello World</h1>\n")
  end
end

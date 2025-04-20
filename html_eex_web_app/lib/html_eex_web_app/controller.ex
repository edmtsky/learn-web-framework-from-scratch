defmodule HtmlEexWebApp.Controller do
  use Plug.Builder

  import Plug.Conn

  def call(conn, action: action) do
    conn = super(conn, [])

    apply(__MODULE__, action, [conn, conn.params])
  end

  def greet(conn, %{"greeting" => greeting}) do
    conn
    |> put_status(200)
    |> render("greet.html.eex", greeting: greeting)
  end

  def greet(conn, _params) do
    send_resp(conn, 400, "<h1>Bad Request</h1>\n")
  end

  @type option_t :: {atom(), String.t()}
  @spec render(Plug.Conn.t(), String.t(), [option_t]) :: Plug.Conn.t()
  def render(conn, file, assigns) do
    HtmlEexWebApp.View.render(conn, file, assigns)
  end
end

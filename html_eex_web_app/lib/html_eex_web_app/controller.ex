defmodule HtmlEexWebApp.Controller do
  use Plug.Builder

  import Plug.Conn
  import Webfw.Controller

  def call(conn, action: action) do
    conn = super(conn, [])

    apply(__MODULE__, action, [conn, conn.params])
  end

  def greet(conn, %{"greeting" => greeting}) do
    conn
    |> put_status(200)
    |> render_html("greet.html.eex", greeting: greeting)
  end

  require EEx

  # wrapper around `Webfw.Controller.render/3` to
  # render html.eex templates from `priv/templates` directory
  defp render_html(conn, file, assigns) do
    contents =
      file
      |> html_file_path()
      |> EEx.eval_file(assigns: assigns)

    render(conn, :html, contents)
  end

  # fetches html file from `priv/templates` directory
  defp html_file_path(file) do
    Path.join([:code.priv_dir(:html_eex_web_app), "templates", file])
  end
end

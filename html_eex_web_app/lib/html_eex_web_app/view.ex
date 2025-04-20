defmodule HtmlEexWebApp.View do
  def render(conn, file, assigns) do
    Webfw.View.render(conn, file, assigns)
  end
end

defmodule Webfw.View do
  require EEx
  alias Webfw.Controller

  def render(conn, file, assigns) do
    contents =
      file
      |> html_file_path()
      |> EEx.eval_file(assigns: assigns)

    Controller.render(conn, :html, contents)
  end

  defp html_file_path(file) do
    templates_path()
    |> Path.join(file)
  end

  defp templates_path() do
    Application.fetch_env!(:webfw, :templates_path)
  end
end

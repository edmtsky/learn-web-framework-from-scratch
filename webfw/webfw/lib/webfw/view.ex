defmodule Webfw.View do
  require EEx
  alias Webfw.Controller

  def render(view_module, conn, file, assigns) do
    functions = view_module.__info__(:functions)

    contents =
      file
      |> html_file_path()
      |> EEx.eval_file(
        [assigns: assigns],
        # will cause  .warning: :functions option in eval is deprecated
        # used to pass public functions from View module into EEx template
        functions: [
          {view_module, functions}
        ]
      )

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

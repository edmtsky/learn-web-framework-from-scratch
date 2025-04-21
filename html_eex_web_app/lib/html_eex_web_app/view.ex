defmodule HtmlEexWebApp.View do
  def render(conn, file, assigns) do
    Webfw.View.render(__MODULE__, conn, file, assigns)
  end

  @doc """
  this function will be accesseble from the EEx template
  just as example to be used in priv/templates/greet.html.eex
  """
  def func_a() do
    "message from func_a"
  end
end

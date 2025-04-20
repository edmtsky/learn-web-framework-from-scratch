defmodule HtmlEexWebApp do

  @doc """
  runs link Plug with Cowboy(http server) to run own WebApp
  """
  def run_with_plug_cowboy() do
    opts = [
      scheme: :http,
      plug: HtmlEexWebApp.Router,
      options: [port: 4040]
    ]

    %{start: {mod, fun, args}} = Plug.Cowboy.child_spec(opts)
    apply(mod, fun, args)
  end
end

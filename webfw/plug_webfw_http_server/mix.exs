defmodule Plug.Webfw.HttpServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_webfw_http_server,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      webfw_http_server_dep(),
      {:plug, "~> 1.17"}
    ]
  end

  defp webfw_http_server_dep() do
    if path = System.get_env("WEBFW_HTTP_SERVER_PATH") do
      {:webfw_http_server, path: path}
    else
      # {:webfw_http_server, "~> 0.1"}
      {:webfw_http_server, path: "../webfw_http_server"}
    end
  end
end

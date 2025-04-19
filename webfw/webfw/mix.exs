defmodule Webfw.MixProject do
  use Mix.Project

  def project do
    [
      app: :webfw,
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
      {:plug, "~> 1.17"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.7"}, # for manual check out
      {:plug_webfw_http_server, path: "../plug_webfw_http_server"}
    ]
  end
end

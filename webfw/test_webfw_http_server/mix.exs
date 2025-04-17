defmodule TestWebfwHttpServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_webfw_http_server,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {TestWebfwHttpServer.Application, []}
    ]
  end

  defp deps do
    [
      {:webfw_http_server, path: "../webfw_http_server"}
    ]
  end
end

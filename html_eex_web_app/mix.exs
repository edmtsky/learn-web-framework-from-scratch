defmodule ExampleHtmlEexServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :html_eex_web_app,
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
      {:webfw, path: "../webfw/webfw"},
      {:floki, "~> 0.37.1", only: :test}
    ]
  end
end

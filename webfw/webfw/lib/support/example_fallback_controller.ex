defmodule WebApp.ExampleFallbackController do
  @moduledoc """
  """
  use Plug.Builder # import Plug.Conn
  import Webfw.Controller

  @fallback_plug WebApp.ExampleFallback

  def call(conn, action: action) do
    conn = super(conn, [])

    unless conn.state == :sent or conn.halted do
      apply_action(conn, action)
    else
      conn
    end
  end

  defp apply_action(conn, action) do
    case apply(__MODULE__, action, [conn, conn.params]) do
      %Plug.Conn{} = conn -> conn
      err -> @fallback_plug.call(conn, err)
    end
  end

  # for route GET /check_fallback?greet=true
  def check_fallback(conn, params) do
    conn = Plug.Conn.fetch_query_params(conn)
    params = Map.merge(params, conn.query_params)

    case validate_params(params) do
      :ok -> redirect(conn, to: "/greet")

      err -> err
    end
  end

  defp validate_params(%{"greet" => "true"}), do: :ok

  defp validate_params(_), do: {:error, :bad_params}

end

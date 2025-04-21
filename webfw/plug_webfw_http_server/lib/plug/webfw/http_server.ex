defmodule Plug.Webfw.HttpServer do
  @moduledoc """
  Documentation for `Plug.Webfw.HTTPServer`.
  """
  @adapter Plug.Webfw.HttpServer.Conn

  def child_spec(plug: plug, port: port, options: options) do
    Application.put_env(
      :webfw_http_server,
      :dispatcher,
      {__MODULE__, [plug: plug, options: options]}
    )

    %{
      id: __MODULE__,
      start: {__MODULE__, :start_linked_server, [port]}
    }
  end

  def start_linked_server(port) do
    Task.start_link(fn ->
      Webfw.HttpServer.start(port)
    end)
  end

  # initialize own plug
  def init(req, method, path, plug: plug, options: opts) do
    conn = conn_from_req(req, method, path)

    %{adapter: {@adapter, _}} =
      conn
      |> plug.call(opts)
      |> maybe_send(plug)

    {:ok, req, {plug, opts}}
  end

  defp maybe_send(%Plug.Conn{state: :unset}, _plug) do
    raise(Plug.Conn.NotSentError)
  end

  defp maybe_send(%Plug.Conn{state: :set} = conn, _plug) do
    Plug.Conn.send_resp(conn)
  end

  defp maybe_send(%Plug.Conn{} = conn, _plug), do: conn

  defp maybe_send(other, plug) do
    raise "Webfw adapter expected #{inspect(plug)} to return Plug.Conn " <>
            "but got: #{inspect(other)}"
  end

  # build Plug.Conn from a client request
  def conn_from_req(req, method, path) do
    {:ok, {remote_ip, _}} = :inet.sockname(req)
    %URI{path: path, query: qs} = URI.parse(path)

    qs = qs || ""

    %Plug.Conn{
      adapter: {@adapter, {req, method, path}},
      host: nil,
      method: Atom.to_string(method),
      owner: self(),
      path_info: path |> Path.relative_to("/") |> Path.split(),
      port: nil,
      remote_ip: remote_ip,
      query_string: qs,
      req_headers: [],
      request_path: path,
      scheme: :http
    }
  end
end

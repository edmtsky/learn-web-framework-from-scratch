defmodule Webfw.HttpServer do
  @moduledoc """
  Starts a HTTP server on the given port
  This server also logs all requests

  function (respond/3 and responder/0) aimed to delegate the response
  generation to a module outside of this module.
  """

  require Logger

  @server_options [
    active: false,
    packet: :http_bin,
    reuseaddr: true
  ]


  @doc """
  used to add HTTP Server to the application's supervision tree
  """
  def child_spec(init_args) do
    %{
      id: __MODULE__,
      start: {
        Task,
        :start_link,
        [fn -> apply(__MODULE__, :start, init_args) end]
      }
    }
  end

  def start(port) do
    ensure_configured!()

    case :gen_tcp.listen(port, @server_options) do
      {:ok, sock} ->
        Logger.info("Started a webserver on port #{port}")
        listen(sock)

      {:error, error} ->
        Logger.error("Cannot start server on port #{port}: #{error}")
    end
  end

  defp ensure_configured!() do
    case dispatcher() do
      nil -> raise "No `dispatcher` configured for `webfw_http_server`"
      _responder -> :ok
    end
  end

  def listen(sock) do
    {:ok, req} = :gen_tcp.accept(sock)
    recv_resp = :gen_tcp.recv(req, 0)

    {
      :ok,
      {_http_req, method, {_type, path}, _v}
    } = recv_resp

    Logger.info("Received HTTP request #{method} at #{path}")

    dispatch(req, method, path)

    listen(sock)
  end

  defp dispatch(req, method, path) do
    case dispatcher() do
      {mod, opts} ->
        mod.init(req, method, path, opts)

      mod ->
        mod.init(req, method, path, [])
    end
  end

  defp dispatcher do
    Application.get_env(:webfw_http_server, :dispatcher)
  end
end

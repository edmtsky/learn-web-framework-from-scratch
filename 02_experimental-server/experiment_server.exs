defmodule ExperimentalServer do
  require Logger

  def start(port) do
    listener_options = [active: false, packet: :http_bin, reuseaddr: true]

    {:ok, listen_socket} = :gen_tcp.listen(port, listener_options)

    IO.puts("Listening on port #{port}")
    listen(listen_socket)
    :gen_tcp.close(listen_socket) # :ok
  end

  defp listen(listen_socket) do
    {:ok, connection_sock} = :gen_tcp.accept(listen_socket)
    {:ok, req} = :gen_tcp.recv(connection_sock, 0)

    Logger.info("Got request: #{inspect req}")
    respond(connection_sock)
    listen(listen_socket)
  end

  defp respond(connection_sock) do
    :gen_tcp.send(connection_sock, "Response from the Server\n")

    Logger.info("Sent response")

    :gen_tcp.close(connection_sock)
  end
end

ExperimentalServer.start(4040)

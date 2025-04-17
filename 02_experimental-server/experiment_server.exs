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
    response = http_1_1_response("Response from the Server\n", 200)
    :gen_tcp.send(connection_sock, response)
    Logger.info("Sent response")

    :gen_tcp.close(connection_sock)
  end

    # Send a proper HTTP/1.1 response with status
  # Converts a body to HTTP/1.1 response string
  defp http_1_1_response(body, status) do
    """
    HTTP/1.1 #{status}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(body)}\r
    \r
    #{body}
    """
  end
end

ExperimentalServer.start(4040)

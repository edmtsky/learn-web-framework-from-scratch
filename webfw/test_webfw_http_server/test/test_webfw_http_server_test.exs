defmodule TestWebfwHttpServerTest do
  use ExUnit.Case
  doctest TestWebfwHttpServer

  setup_all do
    Finch.start_link(name: Webfw.Finch)

    :ok
  end

  # test "greets the world" do
  #   assert TestWebfwHttpServer.hello() == :world
  # end

  describe "start/2" do
    test "starts a server when responder is configured" do
      Task.start_link(fn ->
        Webfw.HttpServer.start(4041)
      end)

      {:ok, response} =
        :get
        |> Finch.build("http://localhost:4041/hello")
        |> Finch.request(Webfw.Finch)

      assert response.body == "Hello World\n"
      assert response.status == 200
      assert {"content-type", "text/html"} in response.headers

      {:ok, response} =
        :get
        |> Finch.build("http://localhost:4041/bad")
        |> Finch.request(Webfw.Finch)

      assert response.body == "Not Found\n"
      assert response.status == 404
      assert {"content-type", "text/html"} in response.headers
    end
  end
end

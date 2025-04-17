defmodule Webfw.HttpServerTest do
  use ExUnit.Case, async: false

  setup_all do
    Finch.start_link(name: Webfw.Finch)

    :ok
  end

  describe "start/2" do
    setup tags do
      responder = tags[:responder]

      old_responder = Application.get_env(:webfw_http_server, :responder)

      Application.put_env(:webfw_http_server, :responder, responder)

      on_exit(fn ->
        Application.put_env(:webfw_http_server, :responder, old_responder)
      end)

      :ok
    end

    @tag responder: nil
    test "raises when responder not configured" do
      assert_raise(
        RuntimeError,
        "No `responder` configured for `webfw_http_server`",
        fn -> Webfw.HttpServer.start(4041) end
      )
    end

    @tag responder: Webfw.TestResponder

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

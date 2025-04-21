defmodule HtmlEexWebApp.ControllerTest do
  use ExUnit.Case
  import Plug.Test
  # import Plug.Conn

  describe "GET /greet" do
    test "responds with an HTML document" do
      conn = conn(:get, "/greet?greeting=Hi")

      conn = HtmlEexWebApp.Router.call(conn, [])

      assert conn.status == 200
      assert conn.resp_body =~ "<h1>Hi World!</h1>"
      assert conn.resp_body =~ "message from func_a"
    end

    # test "raises error if no greeting provided" do
    #   conn = conn(:get, "/greet")
    #
    #   assert_raise(Plug.Conn.WrapperError, fn ->
    #     HtmlEexWebApp.Router.call(conn, [])
    #   end)
    # end

    test "responds with an HTML document (Floki)" do
      conn = conn(:get, "/greet?greeting=Hola")

      conn = HtmlEexWebApp.Router.call(conn, [])

      assert conn.status == 200

      {:ok, html} = Floki.parse_document(conn.resp_body)

      heading =
        html
        |> Floki.find("h1")
        |> Floki.text()

      assert heading == "Hola World!"
    end
  end
end

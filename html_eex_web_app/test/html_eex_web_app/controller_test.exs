defmodule HtmlEexWebApp.ControllerTest do
  use ExUnit.Case
  use Plug.Test

  describe "GET /greet" do
    test "responds with an HTML document" do
      conn = conn(:get, "/greet?greeting=Hi")

      conn = HtmlEexWebApp.Router.call(conn, [])

      assert conn.status == 200
      assert conn.resp_body =~ "<h1>Hi World!</h1>"
    end

    test "raises error if no greeting provided" do
      conn = conn(:get, "/greet")

      assert_raise(Plug.Conn.WrapperError, fn ->
        HtmlEexWebApp.Router.call(conn, [])
      end)
    end
  end
end

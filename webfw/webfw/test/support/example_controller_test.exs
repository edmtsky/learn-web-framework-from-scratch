defmodule WebApp.ExampleControllerTest do
  use ExUnit.Case
  import Plug.Test
  # use Plug.Test
  import Plug.Conn

  describe "GET /greet" do
    test "responds with 200 status" do
      conn = conn(:get, "/greet")

      conn = WebApp.ExampleRouter.call(conn, [])

      assert conn.status == 200
      assert conn.resp_body == Jason.encode!(%{status: "ok"})
    end
  end

  describe "GET /redirect_greet" do
    test "responds with a redirect status" do
      conn = conn(:get, "/redirect_greet")

      conn = WebApp.ExampleRouter.call(conn, [])

      assert conn.status == 302
      assert conn.resp_body =~ "You are being"
      assert conn.resp_body =~ "redirected"
      assert Plug.Conn.get_resp_header(conn, "location") == ["/greet"]
    end
  end
end

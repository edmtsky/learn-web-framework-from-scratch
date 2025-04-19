defmodule WebApp.ExampleFallbackControllerTest do
  use ExUnit.Case
  import Plug.Test
  import Plug.Conn

  describe "GET /check_fallback no query param greet=true" do
    test "responds with 500 status" do
      conn = conn(:get, "/check_fallback")

      conn = WebApp.ExampleRouter.call(conn, [])

      assert conn.status == 500
      assert conn.resp_body == Jason.encode!(%{error: "bad params"})
    end
  end

  describe "GET /check_fallback with greet=true" do
    test "responds with 200 status" do
      conn = conn(:get, "/check_fallback?greet=true")

      conn = WebApp.ExampleRouter.call(conn, [])

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["/greet"]
      assert conn.resp_body =~ "You are being <a href=\"/greet\"> redirected"
    end
  end
end

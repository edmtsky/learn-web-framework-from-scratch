defmodule WebApp.ExampleAuthControllerTest do
  use ExUnit.Case
  import Plug.Test
  import Plug.Conn

  describe "GET /check_auth right token" do
    test "responds with 200 status" do
      conn = conn(:get, "/check_auth")
      conn = put_req_header(conn, "authorization", "Bearer secret")

      conn = WebApp.ExampleRouter.call(conn, [])

      assert conn.status == 200
      assert conn.resp_body == Jason.encode!(%{status: "ok"})
    end
  end

  describe "GET /check_auth without token" do
    test "responds with 401 status" do
      conn = conn(:get, "/check_auth")

      conn = WebApp.ExampleRouter.call(conn, [])

      assert conn.status == 401
      assert conn.resp_body == Jason.encode!(%{status: "Unauthorized"})
    end
  end

  describe "GET /check_auth with wrong token" do
    test "responds with 401 status" do
      conn = conn(:get, "/check_auth")
      conn = put_req_header(conn, "authorization", "Bearer bad")

      conn = WebApp.ExampleRouter.call(conn, [])

      assert conn.status == 401
      assert conn.resp_body == Jason.encode!(%{status: "Unauthorized"})
    end
  end
end

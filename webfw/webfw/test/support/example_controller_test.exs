defmodule Webfw.ExampleControllerTest do
  use ExUnit.Case
  use Plug.Test

  describe "GET /greet" do
    test "responds with 200 status" do
      conn = conn(:get, "/greet")

      conn = Webfw.ExampleRouter.call(conn, [])

      assert conn.status == 200
      assert conn.resp_body == Jason.encode!(%{status: "ok"})
    end
  end
end

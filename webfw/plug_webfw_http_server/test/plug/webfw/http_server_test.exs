defmodule Plug.Webfw.HttpServerTest do
  use ExUnit.Case
  doctest Plug.Webfw.HttpServer

  test "greets the world" do
    assert Plug.Webfw.HttpServer.hello() == :world
  end
end

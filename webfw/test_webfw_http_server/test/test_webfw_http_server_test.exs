defmodule TestWebfwHttpServerTest do
  use ExUnit.Case
  doctest TestWebfwHttpServer

  test "greets the world" do
    assert TestWebfwHttpServer.hello() == :world
  end
end

defmodule CowboyExample.ServerTest do
  use ExUnit.Case

  setup_all do
    Finch.start_link(name: CowboyExample.Finch)

    :ok
  end

  describe "GET /" do
    test "returns Hello World with 200" do
      {:ok, response} =
        :get
        |> Finch.build("http://localhost:4041")
        |> Finch.request(CowboyExample.Finch)

      assert response.body == "Hello World\n"
      assert response.status == 200
      assert {"content-type", "text/html"} in response.headers
    end
  end

  describe "GET /greeting/:who" do
    test "returns Hello `:who` with 200" do
      {:ok, response} =
        :get
        |> Finch.build("http://localhost:4041/greet/Elixir")
        |> Finch.request(CowboyExample.Finch)

      assert response.body == "Hello Elixir\n"
      assert response.status == 200
      assert {"content-type", "text/html"} in response.headers
    end

    test "returns `greeting` `:who` with 200" do
      {:ok, response} =
        :get
        |> Finch.build("http://localhost:4041/greet/Elixir?greeting=Hi")
        |> Finch.request(CowboyExample.Finch)

      assert response.body == "Hi Elixir\n"
      assert response.status == 200
      assert {"content-type", "text/html"} in response.headers
    end
  end

  describe "POST /greeting/:who" do
    test "returns Hello World with 404" do
      {:ok, response} =
        :post
        |> Finch.build("http://localhost:4041/greeting/me")
        |> Finch.request(CowboyExample.Finch)

      # assert response.body == "Not Found\n"
      assert response.status == 404
      assert not ({"content-type", "text/html"} in response.headers)
    end
  end

  describe "Get /static/index.html" do
    test "returns static html page with 200" do
      {:ok, response} =
        :get
        |> Finch.build("http://localhost:4041/static/index.html")
        |> Finch.request(CowboyExample.Finch)

      assert response.body == "<h1>Hello World</h1>\n"
      assert response.status == 200
      assert {"content-type", "text/html"} in response.headers
    end
  end
end

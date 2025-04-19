defmodule Webfw.ExampleRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/greet" do
    Webfw.ExampleController.call(conn, action: :greet)
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

end

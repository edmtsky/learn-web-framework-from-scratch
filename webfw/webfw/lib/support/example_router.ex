defmodule WebApp.ExampleRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/greet" do
    WebApp.ExampleController.call(conn, action: :greet)
  end

  get "/redirect_greet" do
    WebApp.ExampleController.call(conn, action: :redirect_greet)
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

end

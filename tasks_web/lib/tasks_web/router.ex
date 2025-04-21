defmodule TasksWeb.Router do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart],
    pass: ["text/html", "application/*"]

  plug :match
  plug :dispatch

  match _ do
    send_resp(conn, 404, "<h1>Not Found</h1>\n")
  end
end

defmodule TasksWeb.Router do
  use Plug.Router
  alias TasksWeb.TaskController

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart],
    pass: ["text/html", "application/*"]

  plug :match
  plug :dispatch

  get "/tasks/:id/delete", do: TaskController.call(conn, action: :delete)

  get "/tasks", do: TaskController.call(conn, action: :index)

  post "/tasks", do: TaskController.call(conn, action: :create)

  match _ do
    send_resp(conn, 404, "<h1>Not Found</h1>\n")
  end
end

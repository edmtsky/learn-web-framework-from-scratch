defmodule TasksWeb.TaskController do
  use Plug.Builder
  import Plug.Conn
  alias TasksWeb.Tasks

  # Taken from other examples
  def call(conn, action: action) do
    conn = super(conn, [])

    apply(__MODULE__, action, [conn, conn.params])
  end

  # GET
  def index(conn, _params) do
    tasks = Tasks.list()

    conn
    |> put_status(200)
    |> render("tasks.html.eex", tasks: tasks)
  end

  def create(conn, %{"name" => name, "description" => description}) do
    Tasks.add(name, description)

    conn
    |> Webfw.Controller.redirect(to: "/tasks")
  end

  def delete(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> Tasks.delete()

    conn
    |> Webfw.Controller.redirect(to: "/tasks")
  end

  # Taken from other examples
  defp render(conn, file, assigns) do
    TasksWeb.TaskView.render(conn, file, assigns)
  end
end

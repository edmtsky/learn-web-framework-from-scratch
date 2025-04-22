defmodule TasksWeb.TaskControllerTest do
  use ExUnit.Case
  import Plug.Test
  alias TasksWeb.Tasks, as: DB
  # import Plug.Conn

  # BeforeEach
  setup do
    initial_tasks()

    # AfterEach
    on_exit(fn -> DB.delete_all() end)

    :ok
  end

  defp initial_tasks() do
    DB.add("task-name-1", "description-1")
    DB.add("task-name-2", "description-2")
  end

  describe "GET /tasks" do
    test "responds with an HTML document with list of tasks" do
      conn = conn(:get, "/tasks")
      conn = TasksWeb.Router.call(conn, [])

      assert conn.status == 200
      assert conn.resp_body =~ "<h1>Listing Tasks</h1>"
      assert conn.resp_body =~ "<td>task-name-1</td>"
      assert conn.resp_body =~ "<td>description-1</td>"
      assert conn.resp_body =~ "<td>task-name-2</td>"
      assert conn.resp_body =~ "<td>description-2</td>"
    end

    # using Floki
    test "responds with an HTML document with list of tasks 2" do
      conn = conn(:get, "/tasks")
      conn = TasksWeb.Router.call(conn, [])
      # IO.puts(conn.resp_body)

      {:ok, html} = Floki.parse_document(conn.resp_body)
      heading = html |> Floki.find("h1") |> Floki.text()
      assert heading == "Listing TasksAdd new Task"

      rows = html |> Floki.find("table tbody tr")
      assert length(rows) == 2

      [row_1, row_2] = rows
      assert "abc" =~ "ab"
      assert Floki.text(row_1) =~ "task-name-1"
      assert Floki.text(row_1) =~ "description-1"

      assert Floki.text(row_2) =~ "task-name-2"
      assert Floki.text(row_2) =~ "description-2"
    end
  end

  describe "GET /tasks/0/delete" do
    test "responds with redirection" do
      # delete first task
      conn = conn(:get, "/tasks/0/delete")
      conn = TasksWeb.Router.call(conn, [])

      assert conn.status == 302
      assert Plug.Conn.get_resp_header(conn, "location") == ["/tasks"]

      # ensure task was deleted
      assert DB.list() == [{"task-name-2", "description-2"}]
    end
  end

  describe "POST /tasks" do
    # add a new task
    test "responds with an HTML document with list of tasks" do
      conn = conn(:post, "/tasks", %{"name" => "task3", "description" => "desc3"})
      conn = TasksWeb.Router.call(conn, [])

      assert conn.status == 302

      # ensure a task was deleted
      assert DB.list() == [
               {"task-name-1", "description-1"},
               {"task-name-2", "description-2"},
               {"task3", "desc3"}
             ]
    end
  end
end

defmodule TasksWeb.TasksTest do
  use ExUnit.Case
  import TasksWeb.Tasks

  describe "TasksWeb.tasks" do
    test "delete_all" do
      # Create new Storage (Agent process)
      start_link()
      assert list() == []
      add("name1", "descA")
      add("name2", "descB")
      assert list() == [{"name1", "descA"}, {"name2", "descB"}]
      delete_all()
      assert list() == []
    end
  end
end

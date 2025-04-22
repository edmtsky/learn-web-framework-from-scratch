defmodule TasksWeb.Tasks do
  @moduledoc """
  In-memory, volatile store for tasks. Relies on Agent interface.
  """

  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, opts},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def list(), do: Agent.get(__MODULE__, & &1)

  def add(name, description) do
    Agent.update(__MODULE__, & &1 ++ [{name, description}])
  end

  def delete(index) do
    Agent.update(__MODULE__, &List.delete_at(&1, index))
  end

  # for testing
  def delete_all() do
    Agent.update(__MODULE__, fn _state -> [] end)
  end
end

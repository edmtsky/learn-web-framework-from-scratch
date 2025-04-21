defmodule TasksWeb.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {
        Plug.Webfw.HttpServer,
        [
          plug: TasksWeb.Router,
          port: 4040,
          options: []
        ]
      },
      {
        TasksWeb.Tasks,
        # initial state of the store
        []
      }
    ]

    opts = [strategy: :one_for_one, name: TasksWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

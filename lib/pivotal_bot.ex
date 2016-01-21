defmodule PivotalBot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # `start_server` function is used to spawn the worker process
      worker(__MODULE__, [], function: :start_server)
    ]
    opts = [strategy: :one_for_one, name: PivotalBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Start Cowboy server and use our router
  def start_server do
    {:ok, _} = Plug.Adapters.Cowboy.http PivotalBot.Server, []
  end
end

defmodule PivotalBot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(PivotalBot.Bot, [PivotalBot.Bot.slack_token()]),
      worker(PivotalBot.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: PivotalBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

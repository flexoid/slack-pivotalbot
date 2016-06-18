use Mix.Config

config :pivotal_bot, ecto_repos: [PivotalBot.Repo]

config :pivotal_bot, PivotalBot.Repo,
  adapter: Ecto.Adapters.Postgres

import_config "secrets.exs"

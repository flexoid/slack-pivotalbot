defmodule PivotalBot.Repo do
  use Ecto.Repo,
    otp_app: :pivotal_bot,
    adapter: Ecto.Adapters.Postgres
end

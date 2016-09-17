defmodule PivotalBot.Repo.Migrations.AddResponseTsToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :response_ts, :string
    end
  end
end

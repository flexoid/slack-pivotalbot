defmodule PivotalBot.Repo.Migrations.AddMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :channel, :string
      add :ts, :string
      add :story_ids, {:array, :integer}
      timestamps
    end
  end
end

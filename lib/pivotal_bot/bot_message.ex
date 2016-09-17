defmodule PivotalBot.BotMessage do
  use Ecto.Schema

  schema "messages" do
    field :channel, :string, null: false
    field :ts, :string, null: false
    field :story_ids, {:array, :integer}

    timestamps
  end
end

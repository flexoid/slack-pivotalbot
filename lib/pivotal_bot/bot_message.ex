defmodule PivotalBot.BotMessage do
  use Ecto.Schema

  schema "messages" do
    field :ts, :string, null: false
    field :story_ids, {:array, :integer}

    timestamps
  end
end

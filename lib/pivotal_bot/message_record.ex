defmodule PivotalBot.MessageRecord do
  use Ecto.Schema

  schema "messages" do
    field :channel, :string, null: false
    field :ts, :string, null: false
    field :story_ids, {:array, :integer}
    field :response_ts, :string

    timestamps
  end
end

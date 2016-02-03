defmodule PivotalBot.MessageParser do
  @doc """
  Parses story_id from the message.
  """
  def parse(message) do
    regex = ~r/pivotaltracker.com\/story\/show\/(\d+)/i

    regex
    |> Regex.scan(message)
    |> Enum.flat_map(fn([_ | match]) -> match end)
    |> Enum.uniq()
  end
end

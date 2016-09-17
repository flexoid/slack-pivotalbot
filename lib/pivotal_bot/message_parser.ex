defmodule PivotalBot.MessageParser do
  def extract_story_ids(message) do
    regex = ~r/pivotaltracker.com(?:\/n)?\/(?:story\/show|projects\/\d+\/stories)\/(\d+)/i

    regex
    |> Regex.scan(message)
    |> Enum.flat_map(fn([_ | match]) -> match end)
    |> Enum.uniq()
    |> Enum.map(&String.to_integer/1)
  end
end

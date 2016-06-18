defmodule PivotalBot.IncomingProcessor do
  @story_url_base "https://www.pivotaltracker.com/story/show/"

  def prepare_response(message) do
    cond do
      message_from_bot?(message) ->
        {:error, "Ignore bot message"}
      true ->
        ids = PivotalBot.MessageParser.parse(message[:text])
        if length(ids) <= 0 do
          {:error, "No ids in message"}
        else
          {:ok, message_for_stories(ids, message[:channel])}
        end
    end
  end

  defp message_from_bot?(message) do
    !!message[:bot_id]
  end

  defp message_for_stories(story_ids, channel) do
    story_ids
    |> Enum.map(&PivotalBot.StoryFetcher.fetch_story(&1))
    |> PivotalBot.MessageFormatter.build_message(channel)
  end
end

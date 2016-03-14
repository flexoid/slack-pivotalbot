defmodule PivotalBot.IncomingProcessor do
  @story_url_base "https://www.pivotaltracker.com/story/show/"

  def prepare_response(params) do
    cond do
      hook_token_mismatch?(params) ->
        {:error, "Invalid hook token"}
      message_from_bot?(params) ->
        {:error, "Ignore bot message"}
      true ->
        ids = PivotalBot.MessageParser.parse(params["text"])
        if length(ids) <= 0 do
          {:error, "No ids in message"}
        else
          {:ok, message_for_stories(ids)}
        end
    end
  end

  defp message_from_bot?(params) do
    !!params["bot_id"]
  end

  defp hook_token_mismatch?(params) do
    params["token"] != hook_token
  end

  defp message_for_stories(story_ids) do
    story_ids
    |> Enum.map(&PivotalBot.StoryFetcher.fetch_story(&1))
    |> PivotalBot.MessageFormatter.build_message()
  end

  defp hook_token do
    Application.fetch_env!(:pivotal_bot, :pivotal_tracker_hook_token)
  end
end

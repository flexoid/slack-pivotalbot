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
          {:ok, format_message(ids)}
        end
    end
  end

  defp message_from_bot?(params) do
    !!params["bot_id"]
  end

  defp hook_token_mismatch?(params) do
    params["token"] != hook_token
  end

  defp format_message(story_ids) do
    attachments = story_ids
    |> Enum.map(fn story_id ->
      story_title = @story_url_base <> story_id
      story_text = PivotalBot.StoryFetcher.fetch_title(story_id)
      %{title: story_title, title_link: story_title, text: story_text}
    end)

    %{attachments: attachments}
  end

  defp hook_token do
    Application.fetch_env!(:pivotal_bot, :pivotal_tracker_hook_token)
  end
end

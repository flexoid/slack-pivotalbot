defmodule PivotalBot.IncomingHandler do
  require Logger
  alias PivotalBot.{Repo, SlackClient, MessageRecord}

  def handle_async(message) do
    spawn(__MODULE__, :handle, [message])
  end

  def handle(message) do
    case message do
      %{bot_id: _} ->
        nil # Ignoring messages from bots (including this)
      %{text: _} ->
        handle_new_message(message)
      %{subtype: "message_changed", message: _message} ->
        handle_message_update(message)
      %{subtype: "message_deleted", deleted_ts: _deleted_ts} ->
        handle_message_deleting(message)
    end
  end

  defp handle_new_message(%{channel: channel, ts: ts, text: text}) do
    story_ids = PivotalBot.MessageParser.extract_story_ids(text)

    if length(story_ids) > 0 do
      message_record = store_message(channel, ts, story_ids)
      response_message = response_message_for_ids(story_ids, channel)

      post_response = SlackClient.chat_post_message(response_message)
      response_ts = post_response.body["message"]["ts"]
      store_response(message_record, response_ts)
    end
  end

  defp handle_message_update(message) do
    Logger.info("GOT update message: #{inspect(message)}")
  end

  defp handle_message_deleting(%{channel: channel, deleted_ts: deleted_ts}) do
    Logger.info("Deleted message with ts #{deleted_ts} from channel #{channel}")
  end

  defp response_message_for_ids(story_ids, channel) do
    story_ids
    |> Enum.map(&PivotalBot.StoryFetcher.fetch_story(&1))
    |> PivotalBot.MessageFormatter.build_message(channel)
  end

  defp store_message(channel, ts, story_ids) do
    record = %MessageRecord{
      channel: channel,
      ts: ts,
      story_ids: story_ids,
    }
    Repo.insert!(record)
  end

  defp store_response(record, response_ts) when response_ts != nil do
    record = Ecto.Changeset.change(record, response_ts: response_ts)
    Repo.update!(record)
  end
end

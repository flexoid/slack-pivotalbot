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
      Logger.info("Received message [channel: #{inspect(channel)}, " <>
        "ts: #{inspect(ts)}] with story ids: #{inspect(story_ids)}")

      message_record = store_message_record(channel, ts, story_ids)
      response_ts = post_response_message(message_record, channel, ts, story_ids)

      Logger.info("Responded to message [channel: #{inspect(channel)}, " <>
        "ts: #{inspect(ts)}] with message #{inspect(response_ts)}")
    end
  end

  defp post_response_message(message_record, channel, ts, story_ids) do
    response_message = response_message_for_ids(story_ids, channel)

    response = SlackClient.chat_post_message(response_message)
    response_message_ts = response.body["message"]["ts"]

    update_record_for_new_response(message_record, response_message_ts, story_ids)
    response_message_ts
  end

  defp handle_message_update(%{channel: channel, previous_message: %{ts: ts}, message: %{text: text}}) do
    story_ids = PivotalBot.MessageParser.extract_story_ids(text)
    record = find_message_record(channel, ts)

    cond do
      # updated message has stories, and there's bot response to the previous version
      length(story_ids) > 0 && record && record.response_ts ->
        Logger.info("Updated message [channel: #{inspect(channel)}, " <>
          "ts: #{inspect(ts)}] has following ids: #{inspect(story_ids)}")

        response_message = response_message_for_ids(story_ids, channel)
        SlackClient.chat_update(Map.merge(%{ts: record.response_ts}, response_message))
        update_record_for_new_response(record, record.response_ts, story_ids)

      # updated message has no stories, but previos version has bot response
      length(story_ids) == 0 && record && record.response_ts ->
        Logger.info("Updated message [channel: #{inspect(channel)}, " <>
          "ts: #{inspect(ts)}] has no ids, so deleting response")

        delete_response_message(channel, record.response_ts)
        update_record_has_no_response(record)

      # updated message has stories, but there's no bot response to the previous version
      length(story_ids) > 0 ->
        Logger.info("Updated unresponded message [channel: #{inspect(channel)}, " <>
          "ts: #{inspect(ts)}] has following ids: #{inspect(story_ids)}")

        unless record do
          record = store_message_record(channel, ts, story_ids)
        end

        post_response_message(record, channel, ts, story_ids)
      true ->
        nil
    end
  end

  defp handle_message_deleting(%{channel: channel, deleted_ts: deleted_ts}) do
    record = find_message_record(channel, deleted_ts)

    if record && record.response_ts do
      # there was bot response on this message
      delete_response_message(channel, record.response_ts)
    end
  end

  defp response_message_for_ids(story_ids, channel) do
    story_ids
    |> Enum.map(&PivotalBot.StoryFetcher.fetch_story(&1))
    |> PivotalBot.MessageFormatter.build_message(channel)
  end

  defp store_message_record(channel, ts, story_ids) do
    record = %MessageRecord{
      channel: channel,
      ts: ts,
      story_ids: story_ids,
    }
    Repo.insert!(record)
  end

  defp update_record_for_new_response(record, response_ts, story_ids) do
    record = Ecto.Changeset.change(record, response_ts: response_ts, story_ids: story_ids)
    Repo.update!(record)
  end

  defp update_record_has_no_response(record) do
    update_record_for_new_response(record, nil, [])
  end

  defp delete_response_message(channel, ts) do
    SlackClient.chat_delete(channel, ts)
    Logger.info("Deleted response message [channel: #{inspect(channel)}, " <>
      "ts: #{inspect(ts)}]")
  end

  defp find_message_record(channel, ts) do
    Repo.get_by(PivotalBot.MessageRecord, channel: channel, ts: ts)
  end
end

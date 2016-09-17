defmodule PivotalBot.IncomingHandler do
  require Logger
  alias PivotalBot.{Repo, SlackClient, IncomingProcessor, BotMessage}

  def handle_async(message) do
    spawn(__MODULE__, :handle, [message])
  end

  def handle(message) do
    case IncomingProcessor.prepare_response(message) do
      {:ok, ids, response_message} ->
        Logger.info(inspect(ids))
        record = store_message(message, ids)

        post_response = SlackClient.chat_post_message(response_message)
        response_ts = post_response.body["message"]["ts"]
        store_response(record, response_ts)
      {:error, err} ->
        Logger.info(inspect(err))
    end
  end

  defp store_message(message, story_ids) do
    record = %BotMessage{
      channel: message[:channel],
      ts: message[:ts],
      story_ids: story_ids,
    }
    Repo.insert!(record)
  end

  defp store_response(record, response_ts) when response_ts != nil do
    record = Ecto.Changeset.change(record, response_ts: response_ts)
    Repo.update!(record)
  end
end

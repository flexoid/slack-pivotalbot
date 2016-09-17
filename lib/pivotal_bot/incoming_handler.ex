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
        Repo.insert!(%BotMessage{channel: message[:channel], ts: message[:ts], story_ids: ids})
        SlackClient.chat_post_message(response_message)
      {:error, err} ->
        Logger.info(inspect(err))
    end
  end
end

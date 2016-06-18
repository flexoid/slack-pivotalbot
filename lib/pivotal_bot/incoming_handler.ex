defmodule PivotalBot.IncomingHandler do
  require Logger

  def handle_async(message) do
    spawn(__MODULE__, :handle, [message])
  end

  def handle(message) do
    case PivotalBot.IncomingProcessor.prepare_response(message) do
      {:ok, response_message} ->
        PivotalBot.SlackClient.chat_post_message(response_message)
      {:error, err} ->
        Logger.info(inspect(err))
    end
  end
end

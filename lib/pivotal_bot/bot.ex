defmodule PivotalBot.Bot do
  use Slack
  require Logger

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end

  def handle_message(message = %{type: "message"}, _slack) do
    Logger.info("Got message: #{inspect(message)}")
    PivotalBot.IncomingHandler.handle_async(message)
  end

  def handle_message(_, _), do: :ok

  def handle_info(_, _), do: :ok

  def slack_token do
    Application.fetch_env!(:pivotal_bot, :slack_token)
  end
end

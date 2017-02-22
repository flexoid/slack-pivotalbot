defmodule PivotalBot.Bot do
  use Slack
  require Logger

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, _slack, state) do
    PivotalBot.IncomingHandler.handle_async(message)
    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info(_, _, state), do: {:ok, state}

  def slack_token do
    Application.fetch_env!(:pivotal_bot, :slack_token)
  end
end

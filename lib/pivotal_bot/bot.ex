defmodule PivotalBot.Bot do
  use Slack
  require Logger

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_message(message = %{type: "message"}, slack, state) do
    Logger.info("Got message: #{inspect(message)}")
    {:ok, state}
 end

 def handle_message(_message, _slack, state) do
   {:ok, state}
 end

  def start_link do
    start_link(slack_token(), [])
  end

  defp slack_token do
    Application.fetch_env!(:pivotal_bot, :slack_token)
  end
end

defmodule PivotalBot.StoryFetcher do
  @token_header "X-TrackerToken"

  @doc """
  Fetches story
  """
  def fetch_story(story_id) do
    url = "https://www.pivotaltracker.com/services/v5/stories/#{story_id}"

    HTTPoison.get!(url, [{@token_header, token()}]).body
    |> Poison.decode!
  end

  defp token do
    Application.fetch_env!(:pivotal_bot, :pivotal_tracker_secret_token)
  end
end

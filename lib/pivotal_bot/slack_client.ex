defmodule PivotalBot.SlackClient do
  use HTTPoison.Base

  def chat_post_message(message) do
    params = Map.merge(auth_params, message)

    params =
      if params[:attachments] do
        %{params | attachments: Poison.encode!(params[:attachments])}
      else
        params
      end

    post!("/chat.postMessage", params_to_body(params))
  end

  def chat_update(message) do
    params = Map.merge(auth_params, message)

    params =
      if params[:attachments] do
        %{params | attachments: Poison.encode!(params[:attachments])}
      else
        params
      end

    post!("/chat.update", params_to_body(params))
  end

  def chat_delete(channel, ts) do
    Slack.Web.Chat.delete(channel, ts, params_with_auth(%{as_user: true}))
  end

  defp process_url(url) do
    "https://slack.com/api" <> url
  end

  defp process_request_headers(headers) do
    headers ++ ["Content-Type": "application/x-www-form-urlencoded"]
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end

  defp params_to_body(params_map) do
    params_map
    |> Enum.map(fn {key, value} -> "#{key}=#{URI.encode_www_form(value)}" end)
    |> Enum.join("&")
  end

  defp auth_params do
    %{token: Application.fetch_env!(:pivotal_bot, :slack_token)}
  end

  defp params_with_auth(params) do
    Map.merge(params, %{token: Application.fetch_env!(:pivotal_bot, :slack_token)})
  end
end

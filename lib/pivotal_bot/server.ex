defmodule PivotalBot.Server do
  use Plug.Router
  require Logger

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison
  plug :dispatch

  post "/incoming" do
    Logger.info("Got message: #{conn.params}")

    case PivotalBot.IncomingProcessor.prepare_response(conn.params) do
      {:ok, message} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(message))
      {:error, err} ->
        Logger.error(inspect(err))
        conn |> send_resp(200, "")
    end
  end

  match _ do
    send_resp(conn, 404, "Nothing here")
  end
end

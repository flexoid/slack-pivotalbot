defmodule PivotalBot.Mixfile do
  use Mix.Project

  def project do
    [app: :pivotal_bot,
     version: "0.0.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :websocket_client, :slack, :httpoison,
      :poison, :postgrex, :ecto],
     mod: {PivotalBot, []}]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11.0"},
      {:slack, "~> 0.10.0"},
      {:poison, "~> 3.0.0"},
      {:postgrex, "~> 0.13.0"},
      {:ecto, "~> 2.1.3"},
      {:credo, "~> 0.6", only: [:dev, :test]},
      {:distillery, "~> 1.1"}
    ]
  end
end

defmodule PivotalBot.Mixfile do
  use Mix.Project

  def project do
    [app: :pivotal_bot,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :websocket_client, :slack, :httpoison,
      :poison, :postgrex, :ecto],
     mod: {PivotalBot, []}]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.3"},
      {:slack, "~> 0.7.0"},
      {:websocket_client, git: "https://github.com/jeremyong/websocket_client"},
      {:poison, "~> 2.2.0"},
      {:postgrex, "~> 0.12.0"},
      {:ecto, "~> 2.0.5"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:exrm, "~> 1.0.8"},
    ]
  end
end

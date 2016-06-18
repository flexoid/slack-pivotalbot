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
    [applications: [:logger, :slack, :httpoison, :poison, :postgrex, :ecto],
     mod: {PivotalBot, []}]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.1"},
      {:slack, "~> 0.5.0"},
      {:websocket_client, git: "https://github.com/jeremyong/websocket_client"},
      {:poison, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.0.0-rc.6"},
      {:credo, "~> 0.2", only: [:dev, :test]},
      {:exrm, "~> 1.0.3", override: true},
      {:conform, git: "https://github.com/bitwalker/conform", override: true},
      {:conform_exrm, "~> 1.0"},
    ]
  end
end

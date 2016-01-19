# PivotalBot

Slack bot that extracts pivotal tracker story ids from the chat messages and
provides story titles for them.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add pivotal_bot to your list of dependencies in `mix.exs`:

        def deps do
          [{:pivotal_bot, "~> 0.0.1"}]
        end

  2. Ensure pivotal_bot is started before your application:

        def application do
          [applications: [:pivotal_bot]]
        end

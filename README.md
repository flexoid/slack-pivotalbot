# Pivotal Tracker Slack Bot

Slack bot that extracts pivotal tracker story ids from the chat messages and
provides descriptions for them.

## Installation

  1. Provide app config:

        cp config/secrets.exs.example config/secrets.exs
        vim config/secrets.exs

  2. Prepare database:

        mix do ecto.create ecto.migrate

  3. Run:

        iex -S mix

## Release and deploy

Prepare release with following command and run it manually:

    mix release

Or use provided Docker config:

    docker-compose up -d

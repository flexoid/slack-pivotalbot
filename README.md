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

### Manual

Prepare release with following command and run it manually:

    mix release

    rel/pivotal_bot/bin/pivotal_bot foreground

### Docker

Requirements:
  * docker
  * docker-compose

Prepare config for docker release:

    cp config/docker_secrets.exs.example config/docker_secrets.exs
    vim config/docker_secrets.exs

Then use provided script to build and deploy containers:

    ./docker-deploy.sh

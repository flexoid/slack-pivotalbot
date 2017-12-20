#!/bin/sh

set -e

cp config/docker_secrets.exs.example config/docker_secrets.exs

sed -i "s#PIVOTAL_TRACKER_TOKEN#$PIVOTALTRACKER_SECRET_TOKEN#" config/docker_secrets.exs
sed -i "s#SLACK_TOKEN#$BOT_SLACK_TOKEN#" config/docker_secrets.exs

# build app image
docker-compose build

# start postgres
docker-compose up -d db

# wait until database will be accepting connections
docker-compose run --rm bot dockerize -wait tcp://db:5432

# run database migrations
docker-compose run --rm bot sh -c 'MIX_ENV=prod mix ecto.migrate'

# ensure all containers are up and running
docker-compose up -d

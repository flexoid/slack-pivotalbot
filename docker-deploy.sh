#!/bin/bash

# build app image
docker-compose build

# start postgres
docker-compose up -d db

# wait until database will be accepting connections
docker-compose run --rm bot dockerize -wait tcp://db:5432

# run database migrations
docker-compose run bot sh -c 'MIX_ENV=prod mix ecto.migrate'

# ensure all containers are up and running
docker-compose up -d

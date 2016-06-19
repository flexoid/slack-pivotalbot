FROM ubuntu:14.04
MAINTAINER Egor Lynko <flexoid@gmail.com>

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
  apt-get install -y wget git

RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
  dpkg -i erlang-solutions_1.0_all.deb

RUN wget http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc && \
  apt-key add erlang_solutions.asc

RUN apt-get update && \
  apt-get install -y esl-erlang elixir

RUN wget https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.2.0.tar.gz

RUN mix local.hex --force && \
  mix local.rebar --force

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY mix.* ./
RUN mix deps.get --force
RUN MIX_ENV=prod mix compile

COPY lib lib/
COPY priv priv/
COPY config config/

RUN mv config/docker_secrets.exs config/secrets.exs

RUN MIX_ENV=prod mix compile
RUN MIX_ENV=prod mix release --no-confirm-missing

CMD trap exit TERM; rel/pivotal_bot/bin/pivotal_bot foreground & wait

FROM elixir:1.16

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix archive.install hex phx_new 1.7.12 --force

RUN apt-get update && \
    apt-get install -y postgresql-client

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix deps.get

COPY . .

RUN mix compile

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 4000

CMD ["/entrypoint.sh"]

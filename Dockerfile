FROM elixir:1.16-otp-26

WORKDIR /gecko_api

COPY . .

RUN mix deps.get

ENV AUTH_SECRET_KEY=secret_key

RUN mix ecto.setup

CMD [ "mix", "phx.server" ]

EXPOSE 4000

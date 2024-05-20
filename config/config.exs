# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :gecko_api,
  ecto_repos: [GeckoApi.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :gecko_api, GeckoApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: GeckoApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: GeckoApi.PubSub,
  live_view: [signing_salt: "T2qVsICR"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :gecko_api, GeckoApi.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# CORS configuration.
config :cors_plug,
  origin: ["*"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE"]

# Guardian configuration.
config :gecko_api, GeckoApiWeb.Auth.Guardian,
  issuer: "gecko_api",
  secret_key: System.get_env("AUTH_SECRET_KEY")

config :gecko_api, GeckoApiWeb.Auth.Pipeline,
  module: GeckoApiWeb.Auth.Guardian,
  error_handler: GeckoApiWeb.Auth.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

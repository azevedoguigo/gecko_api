defmodule GeckoApi.Repo do
  use Ecto.Repo,
    otp_app: :gecko_api,
    adapter: Ecto.Adapters.Postgres
end

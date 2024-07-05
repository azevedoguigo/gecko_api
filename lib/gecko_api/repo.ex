defmodule GeckoApi.Repo do
  use Ecto.Repo,
    otp_app: :gecko_api,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end

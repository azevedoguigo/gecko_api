defmodule GeckoApiWeb.Auth.Pipeline do
  @moduledoc """
  Provides pipeline with Guardian plugs.
  """
  use Guardian.Plug.Pipeline, otp_app: :gecko_api

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

defmodule GeckoApiWeb.Auth.Guardian do
  @moduledoc """

  """
  use Guardian, otp_app: :gecko_api

  alias Hex.API.User
  alias GeckoApi.Users.User
  alias GeckoApi.Repo

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = Repo.get(User, id)
    {:ok, resource}
  end
end

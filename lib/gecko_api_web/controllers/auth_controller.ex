defmodule GeckoApiWeb.AuthController do
  @moduledoc """

  """
  use GeckoApiWeb, :controller

  alias GeckoApiWeb.Auth.UserAuth

  action_fallback GeckoApiWeb.FallbackController

  def login(conn, params) do
    with {:ok, token} <- UserAuth.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render(:login, token: token)
    end
  end
end

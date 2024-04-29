defmodule GeckoApiWeb.UsersController do
  use GeckoApiWeb, :controller

  alias GeckoApi.Users

  action_fallback GeckoApiWeb.FallbackController

  def create(conn, params) do
    with {:ok, user} <- Users.create_user(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end

  def get(conn, %{"id" => user_id}) do
    with {:ok, user} <- Users.get_user(user_id) do
      conn
      |> put_status(:ok)
      |> render(:get, user: user)
    end
  end
end

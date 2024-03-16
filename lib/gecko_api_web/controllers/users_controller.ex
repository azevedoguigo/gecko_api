defmodule GeckoApiWeb.UsersController do
  use GeckoApiWeb, :controller

  alias GeckoApi.Users

  def create(conn, params) do
    with {:ok, user} <- Users.create_user(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end
end

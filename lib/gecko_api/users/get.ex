defmodule GeckoApi.Users.Get do
  @moduledoc """
  Provides a function call/1 to get user by id.
  """
  alias GeckoApi.Users.User
  alias GeckoApi.Repo

  def call(user_id) do
    case Ecto.UUID.cast(user_id) do
      {:ok, uuid} -> get_user(uuid)
      :error -> {:error, %{message: "Invalid user ID!", status_code: :bad_request}}
    end
  end

  defp get_user(uuid) do
    case Repo.get(User, uuid) do
      nil -> {:error, %{message: "User does not exists!", status_code: :not_found}}
      user -> {:ok, user}
    end
  end
end

defmodule GeckoApiWeb.UsersJSON do
  alias GeckoApi.Users.User

  def create(%{user: user}) do
    %{
      message: "User created successfully!",
      status: 201,
      data: data(user)
    }
  end

  def get(%{user: user}), do: %{status: 200, data: data(user)}

  defp data(%User{} = user) do
    %{
      name: user.name,
      email: user.email,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end

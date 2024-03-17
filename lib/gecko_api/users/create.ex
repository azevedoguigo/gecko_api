defmodule GeckoApi.Users.Create do
  @moduledoc """
  Provides a function call/1 to create a new user.
  """

  alias GeckoApi.Users.User
  alias GeckoApi.Repo

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end

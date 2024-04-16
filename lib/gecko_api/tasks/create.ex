defmodule GeckoApi.Tasks.Create do
  @moduledoc """
  Provides a function call/1 to create a new task.
  """
  alias GeckoApi.Tasks.Task
  alias GeckoApi.Users
  alias GeckoApi.Repo

  def call(params) do
    case Users.get_user(params.user_id) do
      {:ok, _user} -> create_task(params)
      {:error, error_data} -> {:error, error_data}
    end
  end

  defp create_task(params) do
    params
    |> Task.changeset()
    |> Repo.insert()
  end
end

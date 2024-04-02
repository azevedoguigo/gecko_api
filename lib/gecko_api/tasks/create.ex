defmodule GeckoApi.Tasks.Create do
  @moduledoc """
  Provides a function call/1 to create a new task.
  """
  alias GeckoApi.Tasks.Task
  alias GeckoApi.Repo

  def call(params) do
    params
    |> Task.changeset()
    |> Repo.insert()
  end
end

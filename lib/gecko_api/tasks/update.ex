defmodule GeckoApi.Tasks.Update do
  @moduledoc """
  Provides a function call/1 to get task by id.
  """
  alias GeckoApi.Tasks.Task
  alias GeckoApi.Tasks
  alias GeckoApi.Repo

  def call(task_params) do
    case Tasks.get_task(task_params["id"]) do
      {:error, error_data} -> {:error, error_data}
      {:ok, task} -> update(task, task_params)
    end
  end

  defp update(task, task_params) do
    task
    |> Task.changeset(task_params)
    |> Repo.update()
  end
end

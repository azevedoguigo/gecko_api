defmodule GeckoApi.Tasks.Delete do
  @moduledoc """
  Provides a function call/1 to delete task by id.
  """
  alias GeckoApi.Tasks
  alias GeckoApi.Repo

  def call(task_id) do
    case Tasks.get_task(task_id) do
      {:error, error_data} -> {:error, error_data}
      {:ok, task} -> Repo.delete(task)
    end
  end
end

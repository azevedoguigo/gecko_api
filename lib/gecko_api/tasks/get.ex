defmodule GeckoApi.Tasks.Get do
  @moduledoc """
  Provides a function call/1 to get task by id.
  """
  alias GeckoApi.Tasks.Task
  alias GeckoApi.Repo

  def call(task_id) do
    case Ecto.UUID.cast(task_id) do
      {:ok, uuid} -> get_task(uuid)
      :error -> {:error, %{message: "Invalid task ID!", status_code: :bad_request}}
    end
  end

  defp get_task(uuid) do
    case Repo.get(Task, uuid) do
      nil -> {:error, %{message: "Task does not exists!", status_code: :not_found}}
      task -> {:ok, task}
    end
  end
end

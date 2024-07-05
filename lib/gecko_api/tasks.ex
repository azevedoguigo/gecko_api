defmodule GeckoApi.Tasks do
  @moduledoc """
  This module provides function delegations to create, get, and update task data.
  """
  alias GeckoApi.Tasks.{Create, Get, GetAll, Update, Delete}

  defdelegate create_task(task_params), to: Create, as: :call
  defdelegate get_task(task_id), to: Get, as: :call
  defdelegate get_tasks(user_id, params), to: GetAll, as: :call
  defdelegate delete_task(task_id), to: Delete, as: :call
  defdelegate update_task(task_params), to: Update, as: :call
end

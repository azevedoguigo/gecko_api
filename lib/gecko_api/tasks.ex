defmodule GeckoApi.Tasks do
  @moduledoc """
  This module provides function delegations to create, get, and update task data.
  """
  alias GeckoApi.Tasks.{Create, Get, Delete}

  defdelegate create_task(task_params), to: Create, as: :call
  defdelegate get_task(task_id), to: Get, as: :call
  defdelegate delete_task(task_id), to: Delete, as: :call
end

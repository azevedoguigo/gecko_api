defmodule GeckoApi.Tasks do
  @moduledoc """
  This module provides function delegations to create, get, and update task data.
  """
  alias GeckoApi.Tasks.Create

  defdelegate create_task(task_params), to: Create, as: :call
end

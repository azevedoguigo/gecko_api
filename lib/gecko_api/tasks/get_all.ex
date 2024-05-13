defmodule GeckoApi.Tasks.GetAll do
  @moduledoc """
  Provides a function call/1 to get all tasks.
  """
  alias GeckoApi.Repo
  alias GeckoApi.Tasks.Task
  import Ecto.Query

  def call(user_id) do
    from(t in Task, where: t.user_id == ^user_id)
    |> Repo.all()
  end
end

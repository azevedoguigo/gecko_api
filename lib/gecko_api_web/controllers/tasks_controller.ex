defmodule GeckoApiWeb.TasksController do
  @moduledoc """
  Provides actions of tasks.
  """
  use GeckoApiWeb, :controller

  alias GeckoApi.Tasks
  alias GeckoApi.Users.User

  action_fallback GeckoApiWeb.FallbackController

  def create(conn, params) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    params = Map.put(params, "user_id", user_id)

    with {:ok, task} <- Tasks.create_task(params) do
      conn
      |> put_status(:created)
      |> render(:create, task: task)
    end
  end
end

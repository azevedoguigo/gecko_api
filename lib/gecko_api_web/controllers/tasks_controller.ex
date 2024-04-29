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

    params = %{
      title: params["title"],
      description: params["description"],
      user_id: user_id
    }

    with {:ok, task} <- Tasks.create_task(params) do
      conn
      |> put_status(:created)
      |> render(:create, task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, task} <- Tasks.get_task(id) do
      conn
      |> put_status(:ok)
      |> render(:show, task: task)
    end
  end
end

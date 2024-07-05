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

  def show_all(conn, params) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    page = Tasks.get_tasks(user_id, params)

    conn
    |> put_status(:ok)
    |> render(:show_all, tasks: page.entries, page: page)
  end

  def update(conn, params) do
    with {:ok, task} <- Tasks.update_task(params) do
      conn
      |> put_status(:ok)
      |> render(:update, task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, task} <- Tasks.delete_task(id) do
      conn
      |> put_status(:ok)
      |> render(:delete, task: task)
    end
  end
end

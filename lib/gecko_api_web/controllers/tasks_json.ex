defmodule GeckoApiWeb.TasksJSON do
  alias GeckoApi.Tasks.Task

  def create(%{task: task}) do
    %{
      message: "Task created successfully!",
      status: 201,
      data: data(task)
    }
  end

  def show(%{task: task}), do: data(task)

  def show_all(%{tasks: tasks}), do: Enum.map(tasks, fn task -> data(task) end)

  def update(%{task: task}), do: %{message: "Task updated!", task: data(task)}

  def delete(%{task: task}), do: %{message: "Task deleted!", task: data(task)}

  defp data(%Task{} = task) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      completed: task.completed,
      user_id: task.user_id,
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end
end

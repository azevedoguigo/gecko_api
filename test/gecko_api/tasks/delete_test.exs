defmodule GeckoApi.Tasks.DeleteTest do
  use GeckoApi.DataCase

  alias GeckoApi.Users
  alias GeckoApi.Tasks
  alias GeckoApi.Tasks.{Task, Delete}

  setup do
    user_params = %{
      name: "Lewis Hamilton",
      email: "lh44@ferrari.com",
      password: "lewisinferrari"
    }

    {:ok, user} = Users.create_user(user_params)

    {:ok, user: user}
  end

  describe "call/1" do
    test "Delete a task when the id is valid and belongs to an existing task.", %{user: user} do
      user_id = user.id
      task_params = %{
        title: "Create geck api unit tests.",
        description: "Unit tests are useful to ensure scalability and security in API development.",
        user_id: user_id
      }
      {:ok, created_task} = Tasks.create_task(task_params)

      {:ok, task} = Delete.call(created_task.id)

      assert %Task{
        title: "Create geck api unit tests.",
        description: "Unit tests are useful to ensure scalability and security in API development.",
        user_id: ^user_id
      } = task
    end

    test "Returns a tuple with :error and error data if the id is invalid." do
      {:error, error_data} = Delete.call("invalid_id")

      assert %{message: "Invalid task ID!", status_code: :bad_request} == error_data
    end

    test "Returns a tuple with :error and error data if the id does not belong to a task." do
      {:error, error_data} = Delete.call(Ecto.UUID.generate())

      assert %{message: "Task does not exists!", status_code: :not_found} == error_data
    end
  end
end

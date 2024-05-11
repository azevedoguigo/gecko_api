defmodule GeckoApi.Tasks.UpdateTest do
  use GeckoApi.DataCase

  alias GeckoApi.Users
  alias GeckoApi.Tasks
  alias GeckoApi.Tasks.{Task, Update}

  setup do
    user_params = %{
      name: "Lewis Hamilton",
      email: "lh44@ferrari.com",
      password: "lewisinferrari"
    }

    {:ok, user} = Users.create_user(user_params)

    user_id = user.id
      task_params = %{
        title: "Create geck api unit tests.",
        description: "Unit tests are useful to ensure scalability and security in API development.",
        user_id: user_id
      }
      {:ok, task} = Tasks.create_task(task_params)

    {:ok, task: task}
  end

  describe "call/1" do
    test "Returns a tuple with :ok and the updated task if all parameters are valid.", %{task: task} do
      update_params = %{
        "id" => task.id,
        "title" => "Updated title"
      }

      {:ok, updated_task} = Update.call(update_params)

      assert %Task{
        title: "Updated title",
        description: "Unit tests are useful to ensure scalability and security in API development."
      } = updated_task
    end

    test "Returns a tuple with :error and error data if the id is invalid." do
      update_params = %{
        "id" => "invalid_task_id",
        "title" => "Updated title"
      }

      {:error, error_data} = Update.call(update_params)

      assert %{message: "Invalid task ID!", status_code: :bad_request} == error_data
    end

    test "Returns a tuple with :error and error data if the id does not belong to a task." do
      update_params = %{
        "id" => Ecto.UUID.generate,
        "title" => "Updated title"
      }

      {:error, error_data} = Update.call(update_params)

      assert %{message: "Task does not exists!", status_code: :not_found} == error_data
    end

    test "Returns a tuple and an invalid changeset if one or more parameters to be updated are invalid.", %{task: task} do
      update_params = %{
        "id" => task.id,
        "title" => "a" ## Too smal title.
      }

      {:error, invalid_changeset} = Update.call(update_params)

      assert errors_on(invalid_changeset) == %{title: ["should be at least 2 character(s)"]}
    end
  end
end

defmodule GeckoApi.Tasks.CreateTest do
  use GeckoApi.DataCase

  alias GeckoApi.Users
  alias GeckoApi.Tasks.{Task, Create}

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
    test "Return a tuple with :ok and a new task data if all parameters are valid.", %{user: user} do
      user_id = user.id

      task_params = %{
        title: "Create tests of of tasks feature.",
        description: "The tests includes all modules and controllers.",
        user_id: user_id
      }

      result = Create.call(task_params)

      assert {
        :ok,
        %Task{
          title: "Create tests of of tasks feature.",
          description: "The tests includes all modules and controllers.",
          user_id: ^user_id
        }
      } = result
    end

    test "Returns a tuple with :error and error data if the user id are invalid." do
      user_id = "invalid_uuid"

      task_params = %{
        title: "Create tests of of tasks feature.",
        description: "The tests includes all modules and controllers.",
        user_id: user_id
      }

      result = Create.call(task_params)

      assert {:error, %{message: "Invalid user ID!", status_code: :bad_request}} == result
    end

    test "Returns a tuple with :error and error data if the user not exists." do
      user_id = Ecto.UUID.generate()

      task_params = %{
        title: "Create tests of of tasks feature.",
        description: "The tests includes all modules and controllers.",
        user_id: user_id
      }

      result = Create.call(task_params)

      assert {:error, %{message: "User does not exists!", status_code: :not_found}} == result
    end

    test "Return a tuple with :erro and invalid changeset if the some required parameters are invalid.", %{user: user} do
      user_id = user.id

      task_params = %{
        title: "",
        description: "The tests includes all modules and controllers.",
        user_id: user_id
      }

      {:error, invalid_changeset} = Create.call(task_params)

      assert errors_on(invalid_changeset) == %{title: ["can't be blank"]}
    end
  end
end

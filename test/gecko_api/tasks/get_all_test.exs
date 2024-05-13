defmodule GeckoApi.Tasks.GetAllTest do
  use GeckoApi.DataCase

  alias GeckoApi.{Users, Tasks}

  describe "call/1" do
    test "Returns a list of user tasks." do
      user_params = %{
        name: "Lewis Hamilton",
        email: "lh44@ferrari.com",
        password: "lewisinferrari"
      }
      {:ok, user} = Users.create_user(user_params)

      task_params = %{
        title: "Create tests of of tasks feature.",
        description: "The tests includes all modules and controllers.",
        user_id: user.id
      }
      {:ok, _result} = Tasks.create_task(task_params)

      task_list = Tasks.GetAll.call(user.id)

      assert length(task_list) > 0
    end
  end
end

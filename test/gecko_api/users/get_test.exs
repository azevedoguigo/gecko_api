defmodule GeckoApi.Users.GetTest do
  use GeckoApi.DataCase

  alias GeckoApi.Users.{User, Get}
  alias GeckoApi.Users

  describe "call/1" do
    test "Return the user if the id is valid and belongs to the user." do
      user_params = %{
        name: "Sherlock Holmes",
        email: "holmes@gmail.com",
        password: "supersenha"
      }

      {:ok, created_user} = Users.create_user(user_params)

      {:ok, user} = Get.call(created_user.id)

      assert %User{
        name: "Sherlock Holmes",
        email: "holmes@gmail.com",
      } = user
    end

    test "Returns a tuple with :error and error data if the id are invalid." do
      {:error, error_data} = Get.call("invalid_id")

      assert %{message: "Invalid user ID!", status_code: :bad_request} == error_data
    end

    test "Returns a tuple with :error and error data if the id not belong to a user." do
      {:error, error_data} = Get.call("b7d5eeac-dbec-4768-aedb-0f82a963e90c")

      assert %{message: "User does not exists!", status_code: :not_found} == error_data
    end
  end
end

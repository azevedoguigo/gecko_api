defmodule GeckoApi.Users.CreateTest do
  use GeckoApi.DataCase

  alias GeckoApi.Users.{User, Create}

  describe "call/1" do
    test "Creates a new user and returns its data if the parameters are valid." do
      user_params = %{
        name: "Valentino Rossi",
        email: "the.doctor@outlook.com",
        password: "supersenha"
      }

      {:ok, result} = Create.call(user_params)

      assert %User{
        name: "Valentino Rossi",
        email: "the.doctor@outlook.com",
      } = result
    end

    test "Returns an invalid changeset with an error data if one or more parameters are invalid." do
      user_params = %{
        name: "Valentino Rossi",
        email: "", # Can't be blank
        password: "123" # Less than the minimum six characters.
      }

      {:error, invalid_changeset} = Create.call(user_params)

      assert errors_on(invalid_changeset) == %{email: ["can't be blank"], password: ["should be at least 6 character(s)"]}
    end
  end
end

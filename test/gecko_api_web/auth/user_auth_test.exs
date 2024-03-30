defmodule GeckoApiWeb.Auth.UserAuthTest do
  use GeckoApi.DataCase

  alias GeckoApi.Users
  alias GeckoApiWeb.Auth.UserAuth

  setup do
    user_params = %{
      name: "Bruce Dickson",
      email: "b.dickson@gmail.com",
      password: "powerslave"
    }

    {:ok, user} = Users.create_user(user_params)

    {:ok, user: user}
  end

  describe "authenticate/1" do
    test "Returns the token if the credentials are valid.", %{user: user} do
      result = UserAuth.authenticate(%{
        "email" => user.email,
        "password" => user.password
      })

      assert {:ok, _token} = result
    end
  end

  test "Returns a tuple with :error, a map with the error message and the status code if the email is invalid." do
    result = UserAuth.authenticate(%{"email" => "wrong0101@gmail.com", "password" => "supersenha"})

    assert {:error, %{message: "Email not registred!", status_code: :not_found}} == result
  end

  test "Returns a tuple with :error, a map with an error message and a status code when the password is invalid.", %{user: user} do
    result = UserAuth.authenticate(%{"email" => user.email, "password" => "wrong_password"})

    assert {:error, %{message: "Invalid password!", status_code: :unauthorized}} == result
  end
end

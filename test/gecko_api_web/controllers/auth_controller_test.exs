defmodule GeckoApiWeb.AuthControllerTest do
  use GeckoApiWeb.ConnCase

  alias GeckoApi.Users

  setup %{conn: conn} do
    user_params = %{
      name: "Linus Torvalds",
      email: "torvalds@gmail.com",
      password: "supertux"
    }

    {:ok, user} = Users.create_user(user_params)

    {:ok, conn: conn, user: user}
  end

  describe "login/2" do
    test "Returns the token and a status of 200 when the credentials are valid.", %{conn: conn, user: user} do
      response =
        conn
        |> post("/api/login", %{"email" => user.email, "password" => user.password})
        |> json_response(:ok)

      token = response["data"]

      assert %{"data" => ^token, "status" => 200} = response
    end

    test "Returns an error message and a 404 status if the email is invalid.", %{conn: conn, user: user} do
      response =
        conn
        |> post("/api/login", %{"email" => "wrong@gmail.com", "password" => user.password})
        |> json_response(:not_found)

      assert %{"message" => "Email not registred!", "status" => 404} == response
    end

    test "Returns an error message and a 401 status when the password is incorrect.", %{conn: conn, user: user} do
      response =
        conn
        |> post("/api/login", %{"email" => user.email, "password" => "wrong_password"})
        |> json_response(:unauthorized)

      assert %{"message" => "Invalid password!", "status" => 401} == response
    end
  end
end

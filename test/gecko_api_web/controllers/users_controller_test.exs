defmodule GeckoApiWeb.UsersControllerTest do
  use GeckoApiWeb.ConnCase

  describe "create/2" do
    test "Creates a new user and returns it if the parameters are valid.", %{conn: conn} do
      user_params = %{
        name: "Valentino Rossi",
        email: "the.doctor@outlook.com",
        password: "supersenha"
      }

      response =
        conn
        |> post(~p"/api/users", user_params)
        |> json_response(:created)

      assert %{
        "data" => %{
          "name" => "Valentino Rossi",
          "email" => "the.doctor@outlook.com"
        },
        "message" => "User created successfully!",
        "status" => 201
      } = response
    end

    test "Returns error data if one or more parameters are invalid.", %{conn: conn} do
      user_params = %{
        name: "", # Can't be blank.
        email: "the.doctor@outlook.com",
        password: "123" # Less than the minimum six characters.
      }

      response =
        conn
        |> post(~p"/api/users", user_params)
        |> json_response(:bad_request)

      assert  %{"errors" => %{"name" => ["can't be blank"], "password" => ["should be at least 6 character(s)"]}} == response
    end
  end
end

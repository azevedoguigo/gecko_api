defmodule GeckoApiWeb.UsersControllerTest do
  use GeckoApiWeb.ConnCase

  alias GeckoApi.Users

  @user_default_params %{
    name: "Valentino Rossi",
    email: "the.doctor@outlook.com",
    password: "supersenha"
  }

  describe "create/2" do
    test "Creates a new user and returns it if the parameters are valid.", %{conn: conn} do
      response =
        conn
        |> post(~p"/api/users", @user_default_params)
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

  describe "get/2" do
    test "Return the user if the id is valid and belongs to the user.", %{conn: conn} do
      {:ok, created_user} = Users.create_user(@user_default_params)

      response =
        conn
        |> get(~p"/api/users?id=#{created_user.id}")
        |> json_response(:ok)

      assert %{
        "data" => %{
          "name" => "Valentino Rossi",
          "email" => "the.doctor@outlook.com"
        },
        "status" => 200
      } = response
    end

    test "Returns a error message and status 400 if the id are invalid.", %{conn: conn} do
      invalid_id = "invalid_id"

      response =
        conn
        |> get(~p"/api/users?id=#{invalid_id}")
        |> json_response(:bad_request)

      assert %{"message" => "Invalid user ID!", "status" => 400} == response
    end

    test "Returns a error message and status 404 if the id not belong to a user.", %{conn: conn} do
      random_id = Ecto.UUID.generate()

      response =
        conn
        |> get(~p"/api/users?id=#{random_id}")
        |> json_response(:not_found)

      assert %{"message" => "User does not exists!", "status" => 404} == response
    end
  end
end

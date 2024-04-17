defmodule GeckoApiWeb.TasksControllerTest do
  use GeckoApiWeb.ConnCase

  alias GeckoApi.Users
  alias GeckoApiWeb.Auth.Guardian

  setup %{conn: conn} do
    user_default_params = %{
      name: "Valentino Rossi",
      email: "the.doctor@outlook.com",
      password: "supersenha"
    }

    {:ok, user} = Users.create_user(user_default_params)

    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    {:ok, conn: conn, user: user}
  end

  describe "create/2" do
    test "Return a new task data, status code and message if the all params are valid.", %{conn: conn} do
      task_params = %{
        title: "Create tests of of tasks feature.",
        description: "The tests includes all modules and controllers.",
      }

      response =
        conn
        |> post("/api/tasks", task_params)
        |> json_response(:created)

      assert %{
        "data" => %{
          "title" => "Create tests of of tasks feature.",
          "description" => "The tests includes all modules and controllers."
        },
        "message" => "Task created successfully!",
        "status" => 201
      } = response
    end

    test "Return a error message if the some params are invalid.", %{conn: conn} do
      task_params = %{
        title: "",
        description: "The tests includes all modules and controllers.",
      }

      response =
        conn
        |> post("/api/tasks", task_params)
        |> json_response(:bad_request)

      assert %{"errors" => %{"title" => ["can't be blank"]}} == response
    end
  end
end

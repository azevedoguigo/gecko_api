defmodule GeckoApiWeb.TasksControllerTest do
  use GeckoApiWeb.ConnCase

  alias GeckoApi.Users
  alias GeckoApi.Tasks
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

  describe "get/1" do
    test "Returns the task data if the id is valid and belongs to a task.", %{conn: conn, user: user} do
      user_id = user.id

      task_params = %{
        title: "Create tests of of tasks feature.",
        description: "The tests includes all modules and controllers.",
        user_id: user_id
      }

      {:ok, task} = Tasks.create_task(task_params)

      response =
        conn
        |> get("/api/tasks/?id=#{task.id}")
        |> json_response(:ok)

      assert %{
        "completed" => false,
        "description" => "The tests includes all modules and controllers.",
        "title" => "Create tests of of tasks feature.",
        "user_id" => ^user_id
      } = response
    end

    test "Returns an error message and a status code if the task id is invalid.", %{conn: conn} do
      response =
        conn
        |> get("/api/tasks/?id=invalid_id")
        |> json_response(:bad_request)

      assert %{"message" => "Invalid task ID!", "status" => 400} == response
    end

    test "Returns an error message and a status code if the id does not belong to any task", %{conn: conn} do
      response =
        conn
        |> get("/api/tasks/?id=#{Ecto.UUID.generate()}")
        |> json_response(:not_found)

      assert %{"message" => "Task does not exists!", "status" => 404} == response
    end
  end
end

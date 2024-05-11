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
    user_id = user.id

    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    task_params = %{
      title: "Create geck api unit tests.",
      description: "Unit tests are useful to ensure scalability and security in API development.",
      user_id: user_id
    }
    {:ok, task} = Tasks.create_task(task_params)

    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    {:ok, conn: conn, user: user, task: task}
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

  describe "get/2" do
    test "Returns the task data if the id is valid and belongs to a task.", %{conn: conn, task: task} do
      response =
        conn
        |> get("/api/tasks/?id=#{task.id}")
        |> json_response(:ok)

      assert %{
        "completed" => false,
        "description" => "Unit tests are useful to ensure scalability and security in API development.",
        "title" => "Create geck api unit tests.",
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

  describe "update/2" do
    test "Returns a message and the updated task if all parameters to be updated are valid.", %{conn: conn, task: task} do
      update_params = %{
        "title" => "Updated title"
      }

      response =
        conn
        |> put("/api/tasks/?id=#{task.id}", update_params)
        |> json_response(:ok)

      assert %{
        "message" => "Task updated!",
        "task" => %{
          "completed" => false,
          "description" => "Unit tests are useful to ensure scalability and security in API development.",
          "title" => "Updated title"
        }
      } = response
    end

    test "Returns an error message and a status code if the task id is invalid.", %{conn: conn} do
      update_params = %{
        "title" => "Updated title",
      }

      response =
        conn
        |> put("/api/tasks/?id=invalid_id", update_params)
        |> json_response(:bad_request)

      assert %{"message" => "Invalid task ID!", "status" => 400} == response
    end

    test "Returns an error message and a status code if the id does not belong to any task", %{conn: conn} do
      update_params = %{
        "title" => "Updated title",
      }

      response =
        conn
        |> put("/api/tasks/?id=#{Ecto.UUID.generate()}", update_params)
        |> json_response(:not_found)

      assert %{"message" => "Task does not exists!", "status" => 404} == response
    end

    test "Returns error messages if one or more update parameters are invalid.", %{conn: conn, task: task} do
      update_params = %{
        "title" => "a" # Too smal title.
      }

      response =
        conn
        |> put("/api/tasks/?id=#{task.id}", update_params)
        |> json_response(:bad_request)

      assert %{"errors" => %{"title" => ["should be at least 2 character(s)"]}} == response
    end
  end

  describe "delete/2" do
    test "Returns the task data and message if the id is valid and belongs to a task.", %{conn: conn, task: task} do
      response =
        conn
        |> delete("/api/tasks/?id=#{task.id}")
        |> json_response(:ok)

      assert %{
          "message" => "Task deleted!",
          "task" => %{
          "completed" => false,
          "description" => "Unit tests are useful to ensure scalability and security in API development.",
          "title" => "Create geck api unit tests."
          }
        } = response
    end

    test "Returns an error message and a status code if the task id is invalid.", %{conn: conn} do
      response =
        conn
        |> delete("/api/tasks/?id=invalid_id")
        |> json_response(:bad_request)

      assert %{"message" => "Invalid task ID!", "status" => 400} == response
    end

    test "Returns an error message and a status code if the id does not belong to any task", %{conn: conn} do
      response =
        conn
        |> delete("/api/tasks/?id=#{Ecto.UUID.generate()}")
        |> json_response(:not_found)

      assert %{"message" => "Task does not exists!", "status" => 404} == response
    end
  end
end

defmodule GeckoApi.Tasks.TaskTest do
  use GeckoApi.DataCase

  alias GeckoApi.Tasks.Task

  describe "changeset/1" do
    test "Returns a valid changeset if all params are valid." do
      task_params = %{
        title: "Add module docs.",
        description: "Add module docs in User and Task modules today.",
        user_id: Ecto.UUID.generate()
      }

      result = Task.changeset(task_params)

      assert %Ecto.Changeset{
          changes: %{
            title: "Add module docs.",
            description: "Add module docs in User and Task modules today.",
          },
          valid?: true
        } = result
    end

    test "Returns a invalid changeset with error message if the title are blank." do
      task_params = %{
        title: "",
        description: "Add module docs in User and Task modules today.",
        user_id: Ecto.UUID.generate()
      }

      invalid_changeset = Task.changeset(task_params)

      assert errors_on(invalid_changeset) == %{title: ["can't be blank"]}
    end

    test "Returns an invalid changeset with an error message if the title is less than two characters long." do
      task_params = %{
        title: "T",
        description: "Add module docs in User and Task modules today.",
        user_id: Ecto.UUID.generate()
      }

      invalid_changeset = Task.changeset(task_params)

      assert errors_on(invalid_changeset) == %{title: ["should be at least 2 character(s)"]}
    end

    test "Returns an invalid changeset with an error message if the title is longer than forty characters." do
      task_params = %{
        title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        description: "Add module docs in User and Task modules today.",
        user_id: Ecto.UUID.generate()
      }

      invalid_changeset = Task.changeset(task_params)

      assert errors_on(invalid_changeset) == %{title: ["should be at most 40 character(s)"]}
    end

    test "Returns an invalid changeset with an error message and the description is longer than five hundred characters.    " do
      task_params = %{
        title: "Add module docs",
        description: "Lorem Ipsum jest tekstem stosowanym jako przykładowy wypełniacz w przemyśle poligraficznym.
        Został po raz pierwszy użyty w XV w. przez nieznanego drukarza do wypełnienia tekstem próbnej książki.
        Pięć wieków później zaczął być używany przemyśle elektronicznym, pozostając praktycznie niezmienionym.
        Spopularyzował się w latach 60. XX w. wraz z publikacją arkuszy Letrasetu, zawierających fragmenty Lorem Ipsum, a ostatnio z zawierającym różne wersje Lorem Ipsum oprogramowaniem przeznaczonym do realizacji druków na komputerach osobistych, jak Aldus PageMaker
        Lorem Ipsum jest tekstem stosowanym jako przykładowy wypełniacz w przemyśle poligraficznym.
        Został po raz pierwszy użyty w XV w. przez nieznanego drukarza do wypełnienia tekstem próbnej książki.
        Pięć wieków później zaczął być używany przemyśle elektronicznym, pozostając praktycznie niezmienionym.
        Spopularyzował się w latach 60. XX w. wraz z publikacją arkuszy Letrasetu, zawierających fragmenty Lorem Ipsum, a ostatnio z zawierającym różne wersje Lorem Ipsum oprogramowaniem przeznaczonym do realizacji druków na komputerach osobistych, jak Aldus PageMaker",
        user_id: Ecto.UUID.generate()
      }

      invalid_changeset = Task.changeset(task_params)

      assert errors_on(invalid_changeset) == %{description: ["should be at most 500 character(s)"]}
    end
  end
end

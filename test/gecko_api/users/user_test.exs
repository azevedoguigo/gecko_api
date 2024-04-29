defmodule GeckoApi.Users.UserTest do
  use GeckoApi.DataCase

  alias GeckoApi.Users.User
  alias Ecto.Changeset
  alias GeckoApi.Repo

  describe "changeset/1" do
    test "Returns a valid changeset if all parameters are valid." do
      user_params = %{
        name: "Ayrton Senna",
        email: "boss@gmail.com",
        password: "supersenha"
      }

      valid_changeset = User.changeset(user_params)

      assert %Changeset{valid?: true} = valid_changeset
    end

    test "Returns an invalid changeset with an error message if the name is less than two characters." do
      user_params = %{
        name: "A",
        email: "boss@gmail.com",
        password: "supersenha"
      }

      invalid_changeset = User.changeset(user_params)

      assert errors_on(invalid_changeset) == %{name: ["should be at least 2 character(s)"]}
    end

    test "Returns an invalid changeset with an error message if the name is less than 60 characters long." do
      user_params = %{
        name: "Maximiliano Rodrigues de Oliveira Sant'Anna Silveira III",
        email: "oct.max@gmail.com",
        password: "supersenha"
      }

      invalid_changeset = User.changeset(user_params)

      assert errors_on(invalid_changeset) == %{name: ["should be at most 55 character(s)"]}
    end

    test "Returns an invalid changeset with an error message when the email is invalid." do
      user_params = %{
        name: "Ayrton Senna",
        email: "bossgmail.com", # invalid email, don't have "@".
        password: "supersenha"
      }

      invalid_changeset = User.changeset(user_params)

      assert errors_on(invalid_changeset) == %{email: ["has invalid format"]}
    end

    test "Returns an invalid changeset and an error message if the email is longer than forty characters." do
      user_params = %{
        name: "Ayrton Senna",
        email: "maximiliano.rodrigues.oliveira.santAnna@gmail.com",
        password: "supersenha"
      }

      invalid_changeset = User.changeset(user_params)

      assert errors_on(invalid_changeset) == %{email: ["should be at most 40 character(s)"]}
    end

    test "Returns an invalid changeset and an error message if the password is less than six characters long." do
      user_params = %{
        name: "Ayrton Senna",
        email: "boss@gmail.com",
        password: "123"
      }

      invalid_changeset = User.changeset(user_params)

      assert errors_on(invalid_changeset) == %{password: ["should be at least 6 character(s)"]}
    end

    test "Returns an invalid changeset and an error message if the password has a main of thirty characters." do
      user_params = %{
        name: "Ayrton Senna",
        email: "boss@gmail.com",
        password: "1234567891011121314151617181920212232425262728293031" # 31
      }

      invalid_changeset = User.changeset(user_params)

      assert errors_on(invalid_changeset) == %{password: ["should be at most 30 character(s)"]}
    end

    test "Returns an invalid changeset and an error message if the email has already been registered." do
      user_params = %{
        name: "Ayrton Senna",
        email: "boss@gmail.com",
        password: "supersenha"
      }

      valid_changeset = User.changeset(user_params)

      Repo.insert(valid_changeset)
      {:error, invalid_changeset} = Repo.insert(valid_changeset)

      assert errors_on(invalid_changeset) == %{email: ["has already been taken"]}
    end
  end
end

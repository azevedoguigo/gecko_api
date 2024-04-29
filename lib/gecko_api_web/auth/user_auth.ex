defmodule GeckoApiWeb.Auth.UserAuth do
  @moduledoc """
  Provides useful functions for user authentication.
  """

  alias GeckoApiWeb.Auth.Guardian
  alias GeckoApi.Users.User
  alias GeckoApi.Repo

  def authenticate(%{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, %{message: "Email not registred!", status_code: :not_found}}
      user -> validate_password(user, password)
    end
  end

  defp validate_password(%User{password_hash: hash} = user, password) do
    case Argon2.verify_pass(password, hash) do
      true -> generate_token(user)
      false -> {:error, %{message: "Invalid password!", status_code: :unauthorized}}
    end
  end

  defp generate_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, ttl: {8, :hours})
    {:ok, token}
  end
end

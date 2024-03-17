defmodule GeckoApi.Users.User do
  @moduledoc """
  Provides the User schema and changeset functions.
  """
  alias Ecto.Changeset

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @user_params [:name, :email, :password]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @user_params)
    |> validate_required(@user_params)
    |> validate_length(:name, min: 2, max: 55)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, min: 11, max: 40)
    |> validate_length(:password, min: 6, max: 30)
    |> unique_constraint(:email, name: :users_email_index)
    |> add_password_hash()
  end

  defp add_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, %{password_hash: Argon2.hash_pwd_salt(password)})
  end
  defp add_password_hash(changeset), do: changeset
end

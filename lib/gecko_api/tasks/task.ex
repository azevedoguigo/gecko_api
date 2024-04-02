defmodule GeckoApi.Tasks.Task do
  @moduledoc """
  Provides the Task schema and changeset functions.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias GeckoApi.Users.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :completed, :boolean
    belongs_to :user, User

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:title, :description, :user_id])
    |> validate_required([:title, :user_id])
    |> validate_length(:title, min: 2, max: 40)
    |> validate_required(:description, min: 2, max: 500)
    |> cast_assoc(:user)
  end
end

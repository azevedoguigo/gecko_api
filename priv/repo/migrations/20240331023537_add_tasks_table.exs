defmodule GeckoApi.Repo.Migrations.AddTasksTable do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :description, :string
      add :completed, :boolean, default: false
      add :user_id, references(:users, type: :uuid)

      timestamps()
    end
  end
end

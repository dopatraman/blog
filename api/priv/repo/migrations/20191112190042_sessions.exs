defmodule Api.Repo.Migrations.Sessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :user_id, references(:users)
      add :key, :binary_id
      add :expires_at, :utc_datetime

      timestamps()
    end
  end
end

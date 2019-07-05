defmodule Api.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :author_id, references(:users)
      add :content, :text
      add :title, :string
      add :is_private, :boolean, default: false, null: false

      timestamps()
    end
  end
end

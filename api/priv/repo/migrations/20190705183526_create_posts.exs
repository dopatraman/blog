defmodule Api.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :author_id, references(:users)
      add :post_id, :string, null: false
      add :content, :text, null: false
      add :title, :string, null: false
      add :is_private, :boolean, default: false, null: false
      add :is_processed, :boolean, default: false, null: false

      timestamps()
    end
  end
end

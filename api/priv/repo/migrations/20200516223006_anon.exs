defmodule Api.Repo.Migrations.Anon do
  use Ecto.Migration

  def change do
    create table(:anonymous_posts) do
      add :post_id, :string, null: false
      add :content, :text, null: false
      add :title, :string, null: false

      timestamps()
    end
  end
end

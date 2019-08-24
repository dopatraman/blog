defmodule Api.Posts.Context do
  @behaviour Api.Posts.ContextBehaviour

  import Ecto.Query

  alias Ecto.Changeset
  alias Api.Repo
  alias Api.Posts.Schema, as: PostSchema
  alias Api.User.Schema, as: UserSchema

  def insert_post(author, params) do
    %PostSchema{}
    |> Changeset.change()
    |> Changeset.put_change(:author_id, author.id)
    |> PostSchema.changeset(params)
    |> Repo.insert()
  end

  def update_post(post, params) do
    Changeset.change(post)
    |> PostSchema.changeset(params)
    |> Repo.update()
  end

  def get_post(id) do
    PostSchema
    |> Repo.get(id)
  end

  def get_all_posts(author_id) do
    UserSchema
    |> Repo.get(author_id)
    |> for_author()
    |> Repo.all()
  end

  @spec for_author(UserSchema.t()) :: Query.t()
  defp for_author(author) do
    from p in PostSchema, where: p.author_id == ^author.id
  end
end

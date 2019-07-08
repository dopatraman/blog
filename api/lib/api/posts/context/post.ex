defmodule Api.Post.Context do
  @behaviour Api.Post.ContextBehaviour

  import Ecto.Query

  alias Ecto.Changeset
  alias Api.Repo
  alias Api.Post.Schema, as: PostSchema
  alias Api.User.Schema, as: UserSchema

  def insert_post(author, params) do
    %PostSchema{}
    |> Changeset.change()
    |> Changeset.put_change(:author_id, author.id)
    |> PostSchema.changeset(params)
    |> Repo.insert()
  end

  def get_post(id) do
    #  TODO validate the id somehow, bs it's an external input
    PostSchema
    |> Repo.get(id)
  end

  def get_all_posts(author) do
    PostSchema
    |> for_author(author)
    |> Repo.all()
  end

  def get_private_posts(author) do
    PostSchema
    |> for_author(author)
    |> only_private()
    |> Repo.all()
  end

  def get_public_posts(author) do
    PostSchema
    |> for_author(author)
    |> only_public()
    |> Repo.all()
  end

  @spec for_author(PostSchema | Query.t(), UserSchema.t()) :: Query.t()
  defp for_author(query, author) do
    from a in query, where: a.author_id == ^author.id
  end

  @spec only_private(PostSchema | Query.t()) :: Query.t()
  defp only_private(query) do
    from a in query, where: a.is_private == true
  end

  @spec only_private(PostSchema | Query.t()) :: Query.t()
  defp only_public(query) do
    from a in query, where: a.is_private == false
  end
end

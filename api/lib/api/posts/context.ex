defmodule Api.Posts.Context do
  import Ecto.Query

  alias Ecto.Changeset
  alias Api.Repo
  alias Api.Posts.Schema, as: PostSchema
  alias Api.Posts.AnonymousPost, as: AnonymousPostSchema
  alias Api.User.Schema, as: UserSchema
  alias Api.Posts.Helpers

  def get_post_by_post_id(post_id) do
    PostSchema
    |> where([p], p.post_id == ^post_id)
    |> Repo.one()
  end

  def get_anonymous_post_by_post_id(post_id) do
    AnonymousPostSchema
    |> where([p], p.post_id == ^post_id)
    |> Repo.one()
  end

  def insert_post(%{"author_id" => author_id} = params) when is_number(author_id) do
    UserSchema
    |> Repo.get(author_id)
    |> case do
      nil -> insert_post_nil(nil)
      user -> insert_post_for_author(user, params)
    end
  end

  def insert_anonymous_post(params) do
    %AnonymousPostSchema{}
    |> Changeset.change()
    |> Changeset.put_change(:post_id, Helpers.generate_post_id(Map.get(params, "title")))
    |> AnonymousPostSchema.changeset(params)
    |> Repo.insert()
  end

  defp insert_post_for_author(%UserSchema{} = author, params) do
    %PostSchema{}
    |> Changeset.change()
    |> Changeset.put_change(:author_id, author.id)
    |> Changeset.put_change(:post_id, Helpers.generate_post_id(author.id))
    |> PostSchema.changeset(params)
    |> Repo.insert()
  end

  defp insert_post_nil(nil), do: {:error, :does_not_exist}

  def get_post_with_author(id) do
    get_post(id)
    |> Repo.preload([:author])
  end

  defp get_post(id) do
    PostSchema
    |> Repo.get(id)
  end

  @spec get_next_post(PostSchema.t()) :: Query.t()
  def get_next_post(post) do
    PostSchema
    |> author_non_private(post.author_id)
    |> where([p], p.inserted_at > ^post.inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  @spec get_prev_post(PostSchema.t()) :: Query.t()
  def get_prev_post(post) do
    PostSchema
    |> author_non_private(post.author_id)
    |> where([p], p.inserted_at < ^post.inserted_at)
    |> order_by([p], desc: p.inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  def get_latest_post_for_author(username) when is_binary(username) do
    for_author_name(username)
    |> limit(1)
    |> Repo.one()
    |> Repo.preload([:author])
  end

  @spec for_author_name(String.t()) :: Query.t()
  defp for_author_name(username) do
    from p in PostSchema,
      join: users in UserSchema,
      on: p.author_id == users.id,
      where: users.username == ^username,
      order_by: [desc: p.inserted_at]
  end

  defp author_non_private(schema, author_id) do
    where(schema, [p], p.author_id == ^author_id)
    |> where([p], not p.is_private)
  end
end

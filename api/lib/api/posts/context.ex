defmodule Api.Posts.Context do
  @behaviour Api.Posts.ContextBehaviour

  import Ecto.Query

  alias Ecto.Changeset
  alias Api.Repo
  alias Api.Posts.Schema, as: PostSchema
  alias Api.User.Schema, as: UserSchema

  def insert_post(%{"author_id" => author_id} = params) when is_number(author_id) do
    UserSchema
    |> Repo.get(author_id)
    |> case do
      nil -> insert_post_nil(nil)
      user -> insert_post_for_author(user, params)
    end
  end

  defp insert_post_for_author(%UserSchema{} = author, params) do
    %PostSchema{}
    |> Changeset.change()
    |> Changeset.put_change(:author_id, author.id)
    |> PostSchema.changeset(params)
    |> Repo.insert()
  end

  defp insert_post_nil(nil), do: {:error, :does_not_exist}

  def get_post(id) do
    PostSchema
    |> Repo.get(id)
  end

  def get_all_posts(author_id) do
    UserSchema
    |> Repo.get(author_id)
    |> case do
      nil -> {:error, :does_not_exist}
      user -> Repo.all(for_author(user))
    end
  end

  def get_latest_post_for_author(author_id) do
    UserSchema
    |> Repo.get(author_id)
    |> case do
      nil -> {:error, :does_not_exist}
      user -> for_author(user)
    end
    |> case do
      %Ecto.Query{} = query -> for_latest(query)
      _ = error -> error
    end
    |> Repo.one()
  end

  @spec for_author(UserSchema.t()) :: Query.t()
  defp for_author(author) do
    from p in PostSchema, where: p.author_id == ^author.id
  end

  @spec for_latest(PostSchema.t()) :: Query.t()
  defp for_latest(posts) do
    from p in posts, order_by: [desc: p.inserted_at], limit: 1
  end
end

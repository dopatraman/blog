defmodule Api.Post.Service do
  @behaviour Api.Post.ServiceBehaviour
  @post_context Application.get_env(:api, :post_context)

  alias Api.Repo
  alias Api.User.Schema, as: UserSchema

  def create_post(
        %{
          "author_id" => author_id,
          "title" => _title,
          "content" => _content,
          "is_private" => _is_private
        } = params
      ) do
    UserSchema
    |> Repo.get(author_id)
    |> case do
      nil -> {:error, :does_not_exist}
      user -> @post_context.insert_post(user, params)
    end
  end

  def get_post_by_id(author_id, post_id) do
    UserSchema
    |> Repo.get(author_id)
    |> case do
      nil -> {:error, :does_not_exist}
      _ -> {:ok, @post_context.get_post(post_id)}
    end
  end

  def get_posts_by_author(author_id) do
    UserSchema
    |> Repo.get(author_id)
    |> case do
      nil -> {:error, :does_not_exist}
      user -> @post_context.get_all_posts(user)
    end
  end
end

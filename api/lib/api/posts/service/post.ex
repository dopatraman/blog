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
    # ensure access
    # validate input
    # validate business rules
    # call context
    UserSchema
    |> Repo.get(author_id)
    |> ensure_access()
    |> @post_context.insert_post(params)
  end

  def get_post_by_id(id) do
    case @post_context.get_post(id) do
      nil -> {:error, :does_not_exist}
      post -> {:ok, post}
    end
  end

  def get_posts_by_author(author_id, true = _is_private) do
    UserSchema
    |> Repo.get(author_id)
    |> ensure_access()
    |> @post_context.get_private_posts()
  end

  def get_posts_by_author(author_id, false = _is_private) do
    UserSchema
    |> Repo.get(author_id)
    |> ensure_access()
    |> @post_context.get_public_posts()
  end

  defp ensure_access(nil), do: nil
  defp ensure_access(user), do: user
end

defmodule Api.Post.Service do
  @behaviour Api.Post.ServiceBehaviour
  @post_context Application.get_env(:api, :post_context)

  alias Api.Repo
  alias Api.User.Schema, as: UserSchema

  def create_post(author_id, title, content, is_private) do
    # ensure access
    # validate input
    # validate business rules
    # call context
    UserSchema
    |> Repo.get(author_id)
    # |> ensure_access()
    |> @post_context.insert_post(title, content, is_private)
  end

  def get_post_by_id(id, author_id) do
  end

  def get_posts_by_author(author_id, true = is_private) do
  end

  def get_posts_by_author(author_id, false = is_private) do
  end

  defp ensure_access(x) do
    x
  end
end

defmodule ApiWeb.PostsController do
  @post_service Application.get_env(:api, :post_service)

  use ApiWeb, :controller

  # GET /posts
  def index(conn, %{"author_id" => author_id}) do
    posts = @post_service.get_posts_by_author(author_id)
    json(conn, posts)
  end

  def show(conn, %{"id" => post_id, "author_id" => author_id}) do
    case @post_service.get_post_by_id(author_id, post_id) do
      {:ok, post} -> put_status(conn, 200) |> json(post)
      _ -> put_status(conn, 500) |> json(:error)
    end
  end

  # POST /posts
  def create(%Plug.Conn{assigns: %{current_user_id: author_id}} = conn, params) do
    params
    |> Map.put("author_id", author_id)
    |> @post_service.create_post()
    |> case do
      {:ok, post} -> json(conn, post)
      {:error, _} -> put_status(conn, 500) |> json(:error)
    end
  end

  def create(conn, _), do: put_status(conn, 500) |> json(:error)
end

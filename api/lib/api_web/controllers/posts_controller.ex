defmodule ApiWeb.PostsController do
  @post_service Application.get_env(:api, :post_service)

  use ApiWeb, :controller

  # GET /posts
  def index(conn, %{"author_id" => author_id}) do
    posts = @post_service.get_posts_by_author(author_id)
    json(conn, posts)
  end

  def show(conn, %{"id" => post_id, "author_id" => author_id}) do
    post = @post_service.get_post_by_id(author_id, post_id)
  end

  # POST /posts
  def create(conn, params) do
    params
    |> @post_service.create_post()
    |> case do
      {:ok, post} -> json(conn, post)
      {:error, _} -> put_status(conn, 500)
    end
  end
end

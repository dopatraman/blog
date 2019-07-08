defmodule ApiWeb.PostsController do
  @post_service Application.get_env(:api, :post_service)

  use ApiWeb, :controller

  # GET /posts
  def index(conn, %{"author_id" => author_id}) do
    posts = @post_service.get_posts_by_author(author_id)
    json(conn, posts)
  end

  # GET /posts/:id/edit
  def edit(conn, _params), do: :ok

  # GET /posts/new
  def new(conn, _params), do: :ok

  # GET /posts/:id
  def show(conn, _params), do: :ok

  # POST /posts
  def create(conn, _params), do: :ok

  # PATCH/PUT /posts/:id
  def update(conn, _params), do: :ok

  # DELETE /posts/:id
  def delete(conn, _params), do: :ok
end

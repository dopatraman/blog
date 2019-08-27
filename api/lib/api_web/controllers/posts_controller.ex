defmodule ApiWeb.PostsController do
  @post_context Application.get_env(:api, :post_context)

  use ApiWeb, :controller

  # GET /posts
  def index(conn, %{"author_id" => author_id}) do
    posts = @post_context.get_all_posts(author_id)
    json(conn, posts)
  end

  def show(conn, %{"id" => post_id}) do
    case @post_context.get_post(post_id) do
      nil -> put_status(conn, 500) |> json(:error)
      post -> put_status(conn, 200) |> json(post)
    end
  end

  # POST /posts
  def create(%Plug.Conn{assigns: %{current_user_id: author_id}} = conn, params) do
    {author_id, ""} = Integer.parse(author_id)
    params
    |> Map.put("author_id", author_id)
    |> @post_context.insert_post()
    |> case do
      {:ok, post} -> json(conn, post)
      {:error, _} -> put_status(conn, 500) |> json(:error)
    end
  end

  def create(conn, _), do: put_status(conn, 500) |> json(:error)
end

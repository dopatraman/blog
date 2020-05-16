defmodule ApiWeb.PostsController do
  @post_context Application.get_env(:api, :post_context)

  use ApiWeb, :controller
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint

  # POST /posts
  def create(%Plug.Conn{assigns: %{current_user: author}} = conn, params) do
    params
    |> Map.put("author_id", author.id)
    |> @post_context.insert_post()
    |> case do
      {:ok, post} -> redirect(conn, to: Routes.read_path(Endpoint, :post, post.post_id))
      {:error, _} -> put_status(conn, 500) |> redirect(to: "/create")
    end
  end

  def create(conn, _), do: put_status(conn, 500) |> json(:error)

  def create_anonymous_post(conn, params) do
    @post_context.insert_anonymous_post(params)
    |> case do
      {:ok, post} -> redirect(conn, to: Routes.read_path(Endpoint, :anonymous_post, post.post_id))
      {:error, _} -> put_status(conn, 500) |> redirect(to: "/write")
    end
  end
end

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
      {:ok, _post} -> redirect(conn, to: Routes.page_path(Endpoint, :latest, author.id))
      {:error, _} -> put_status(conn, 500) |> redirect(to: "/create")
    end
  end

  def create(conn, _), do: put_status(conn, 500) |> json(:error)
end

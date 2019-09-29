defmodule ApiWeb.PageController do
  @post_context Application.get_env(:api, :post_context)
  use ApiWeb, :controller

  def login(conn, _) do
    render(conn, "login.html")
  end

  def create_post(conn, _) do
    render(conn, "create.html")
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # GET/latest
  def latest(conn, %{"author_id" => author_id}) do
    case @post_context.get_latest_post_for_author(author_id) do
      nil -> put_status(conn, 500) |> json(:error)
      post -> render_post(conn, "latest.html", post)
    end
  end

  defp render_post(conn, form_name, %Api.Posts.Schema{} = post) do
    r_post = HTMLDisplayable.from(post)
    render(conn, form_name, title: r_post.title, content: r_post.content)
  end
end

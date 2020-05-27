defmodule ApiWeb.PageController do
  @post_context Application.get_env(:api, :post_context)
  use ApiWeb, :controller

  def login(conn, _), do: render(conn, "login.html")

  def create_post(conn, _), do: render(conn, "create.html")

  def create_anonymous_post(conn, _), do: render(conn, "create-anon.html")

  def index(conn, _params), do: redirect(conn, to: "/write")

  # GET/latest
  def latest(conn, %{"username" => username}) do
    case @post_context.get_latest_post_for_author(username) do
      nil ->
        put_status(conn, 404) |> json(:error)

      post ->
        prev_post = @post_context.get_prev_post(post)
        next_post = @post_context.get_next_post(post)

        render_post(
          conn,
          "latest.html",
          post,
          post_title(prev_post),
          post_id(prev_post),
          post_title(next_post),
          post_id(next_post)
        )
    end
  end

  defp render_post(
         conn,
         form_name,
         %Api.Posts.Schema{} = post,
         prev_post_title,
         prev_post_id,
         next_post_title,
         next_post_id
       ) do
    r_post = HTMLDisplayable.from(post)

    render(conn, form_name,
      title: r_post.title,
      content: r_post.content,
      prev_title: prev_post_title,
      prev_link: "/users/#{post.author.username}/#{prev_post_id}",
      next_title: next_post_title,
      next_link: "/users/#{post.author.username}/#{next_post_id}"
    )
  end

  defp post_title(nil), do: nil
  defp post_title(post), do: post.title

  defp post_id(nil), do: nil
  defp post_id(post), do: post.id
end

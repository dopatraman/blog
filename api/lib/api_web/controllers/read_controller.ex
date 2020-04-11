defmodule ApiWeb.ReadController do
  @post_context Application.get_env(:api, :post_context)
  use ApiWeb, :controller

  def post(conn, %{"post_id" => post_id}) do
    case @post_context.get_post_by_post_id(post_id) do
      nil ->
        put_status(conn, 404) |> json(:error)

      post ->
        r_post = HTMLDisplayable.from(post)

        render(conn, "post.html",
          title: r_post.title,
          content: r_post.content
        )
    end
  end
end

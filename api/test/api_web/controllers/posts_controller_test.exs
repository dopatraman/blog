defmodule ApiWeb.PostsControllerTest do
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint
  import Api.Factory
  use ApiWeb.ConnCase

  test "GET /posts", %{conn: conn} do
    author = insert(:user)
    post = insert(:post, author: author)

    [resp_post] =
      get(conn, Routes.posts_path(Endpoint, :index, author_id: author.id))
      |> json_response(200)

    assert resp_post["author_id"] == post.author.id
    assert resp_post["content"] == post.content
    assert resp_post["title"] == post.title
  end
end

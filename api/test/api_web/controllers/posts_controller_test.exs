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

  test "POST /posts", %{conn: conn} do
    author = insert(:user)

    resp =
      post(
        conn,
        Routes.posts_path(Endpoint, :create, %{
          "author_id" => author.id,
          "title" => "My New Post",
          "content" => "Hahaha",
          "is_private" => false
        })
      )
      |> json_response(200)

    assert resp["author_id"] == author.id
    assert resp["title"] == "My New Post"
    assert resp["content"] == "Hahaha"
    assert !resp["is_private"]
  end
end

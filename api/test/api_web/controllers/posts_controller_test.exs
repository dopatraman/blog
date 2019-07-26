defmodule ApiWeb.PostsControllerTest do
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint
  import Api.Factory
  use ApiWeb.ConnCase

  setup %{conn: conn, bypass_auth: true} do
    author = insert(:user)
    post = insert(:post, author: author)

    {:ok, token, _} = Api.Auth.Guardian.encode_and_sign(author, %{}, token_type: :access)
    %{
      conn: put_req_header(conn, "authorization", "Bearer: " <> token),
      author: author,
      post: post
     }
  end

  @tag :bypass_auth
  test "GET /posts", %{conn: conn, author: author, post: post} do
    [resp_post] =
      get(conn, Routes.posts_path(Endpoint, :index, author_id: author.id))
      |> json_response(200)

    assert resp_post["author_id"] == post.author.id
    assert resp_post["content"] == post.content
    assert resp_post["title"] == post.title
  end

  @tag :bypass_auth
  test "POST /posts", %{conn: conn, author: author} do
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

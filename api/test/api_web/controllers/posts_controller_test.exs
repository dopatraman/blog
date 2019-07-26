defmodule ApiWeb.PostsControllerTest do
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint
  import Api.Factory
  use ApiWeb.ConnCase

  defp add_auth_header(conn, user) do
    {:ok, token, _} = Api.Auth.Guardian.encode_and_sign(user, %{}, token_type: :access)
    put_req_header(conn, "authorization", "Bearer: " <> token)
  end

  setup %{conn: conn, needs_auth: needs_auth} do
    author = insert(:user)
    post = insert(:post, author: author)

    conn =
      case needs_auth do
        true -> add_auth_header(conn, author)
        _ -> conn
      end

    %{
      conn: conn,
      author: author,
      post: post
    }
  end

  @tag needs_auth: false
  test "GET /posts", %{conn: conn, author: author, post: post} do
    [resp_post] =
      get(conn, Routes.posts_path(Endpoint, :index, author_id: author.id))
      |> json_response(200)

    assert resp_post["author_id"] == post.author.id
    assert resp_post["content"] == post.content
    assert resp_post["title"] == post.title
  end

  @tag needs_auth: false
  test "GET /posts/:id", %{conn: conn, author: author, post: post} do
    resp_post =
      get(conn, Routes.posts_path(Endpoint, :show, post.id, author_id: author.id))
      |> json_response(200)

    assert resp_post["author_id"] == post.author.id
    assert resp_post["content"] == post.content
    assert resp_post["title"] == post.title
  end

  @tag needs_auth: true
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

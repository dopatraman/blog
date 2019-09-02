defmodule ApiWeb.PostsControllerTest do
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint
  import Api.Factory
  import Plug.Conn, only: [get_resp_header: 2, put_req_header: 3]
  use ApiWeb.ConnCase

  defp login(conn, user, raw_password) do
    [token] =
      conn
      |> put_req_header("content-type", "application/json")
      |> post(
        Routes.auth_path(Endpoint, :login,
          user: %{
            "username" => user.username,
            "password" => raw_password
          }
        )
      )
      |> get_resp_header("authorization")

    {:ok, token}
  end

  defp add_auth_header(conn, user, raw_password) do
    {:ok, token} = login(conn, user, raw_password)
    put_req_header(conn, "authorization", token)
  end

  setup %{conn: conn, needs_auth: needs_auth} do
    raw_password = "pwnage"
    author = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))
    post = insert(:post, author: author)

    conn =
      case needs_auth do
        true -> add_auth_header(conn, author, raw_password)
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
      get(conn, Routes.posts_path(Endpoint, :index, author.id))
      |> json_response(200)

    assert resp_post["author_id"] == post.author.id
    assert resp_post["content"] == post.content
    assert resp_post["title"] == post.title
  end

  @tag needs_auth: false
  test "GET /posts/:id", %{conn: conn, author: author, post: post} do
    resp_post =
      get(conn, Routes.posts_path(Endpoint, :show, author.id, post.id))
      |> json_response(200)

    assert resp_post["author_id"] == post.author.id
    assert resp_post["content"] == post.content
    assert resp_post["title"] == post.title
  end

  @tag needs_auth: true
  test "POST /posts with access controls", %{conn: conn, author: author} do
    resp =
      post(
        conn,
        Routes.posts_path(Endpoint, :create, %{
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

  @tag needs_auth: false
  test "/GET latest post", %{conn: conn, author: author} do
    post3 = insert(:post, author: author, inserted_at: ~N[2019-08-29 20:11:44])

    resp =
      get(
        conn,
        Routes.posts_path(Endpoint, :latest, author.id)
      )
      |> json_response(200)

    assert resp["author_id"] == post3.author_id
  end

  @tag needs_auth: false
  test "/GET latest post should return an error", %{conn: conn} do
    new_author = insert(:user)

    get(
      conn,
      Routes.posts_path(Endpoint, :latest, new_author.id)
    )
    |> json_response(500)
  end
end

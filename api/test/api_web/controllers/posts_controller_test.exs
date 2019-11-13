defmodule ApiWeb.PostsControllerTest do
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint
  import Api.Factory
  import Plug.Conn, only: [get_resp_header: 2, put_req_header: 3]
  use ApiWeb.ConnCase

  setup %{conn: conn} do
    raw_password = "pwnage"
    author = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))
    post = insert(:post, author: author)
    session = insert(:session, user: author)

    %{
      conn: conn,
      author: author,
      post: post,
      session: session
    }
  end

  test "POST /posts with active session", %{conn: conn, author: author, session: session} do
    conn = put_req_header(conn, "cookie", "id=#{session.key}")

    resp =
      post(
        conn,
        Routes.posts_path(Endpoint, :create, %{
          "title" => "My New Post",
          "content" => "Hahaha",
          "is_private" => false
        })
      )

    assert resp.status == 302
    assert resp.assigns.current_user != nil
    assert resp.assigns.current_user == author

    [_redirect_path] = get_resp_header(resp, "location")
  end

  test "POST /posts without session", %{conn: conn} do
    resp =
      post(
        conn,
        Routes.posts_path(Endpoint, :create, %{
          "title" => "My New Post",
          "content" => "Hahaha",
          "is_private" => false
        })
      )

    assert resp.status == 500
  end
end

defmodule ApiWeb.AuthControllerTest do
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint
  alias Plug.Conn.Cookies
  alias Ecto.UUID

  import Api.Factory
  import Plug.Conn, only: [get_resp_header: 2, fetch_cookies: 2]
  use ApiWeb.ConnCase

  test "get login token successfully", %{conn: conn} do
    raw_password = "password"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))

    resp =
      conn
      |> put_req_header("content-type", "application/json")
      |> post(
        Routes.auth_path(
          Endpoint,
          :login,
          user: %{
            "username" => user.username,
            "password" => raw_password
          }
        )
      )

    [cookie] = get_resp_header(resp, "set-cookie")
    [redirect_path] = get_resp_header(resp, "location")
    assert cookie !== nil
    %{"id" => uuid} = Cookies.decode(cookie)
    {:ok, _} = UUID.cast(uuid)

    assert resp.status == 302
    assert redirect_path == "/create"
  end

  test "bad login", %{conn: conn} do
    bad_raw_password = "bad_password"
    raw_password = "password"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))

    resp =
      conn
      |> put_req_header("content-type", "application/json")
      |> post(
        Routes.auth_path(
          Endpoint,
          :login,
          user: %{
            "username" => user.username,
            "password" => bad_raw_password
          }
        )
      )

    [] = get_resp_header(resp, "set-cookie")
    [redirect_path] = get_resp_header(resp, "location")
    assert resp.status == 500
    assert redirect_path == "/login"
  end
end

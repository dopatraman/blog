defmodule ApiWeb.SessionControllerTest do
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint
  import Api.Factory
  import Plug.Conn, only: [get_resp_header: 2]
  use ApiWeb.ConnCase

  test "get login token successfully", %{conn: conn} do
    raw_password = "password"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))

    resp =
      conn
      |> put_req_header("content-type", "application/json")
      |> post(
        Routes.session_path(Endpoint, :login,
          user: %{
            "username" => user.username,
            "password" => raw_password
          }
        )
      )

    [token] = get_resp_header(resp, "authorization")

    assert token !== nil

    json_response(resp, 200)
  end

  test "bad login", %{conn: conn} do
    bad_raw_password = "bad_password"
    raw_password = "password"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))

    _resp =
      conn
      |> put_req_header("content-type", "application/json")
      |> post(
        Routes.session_path(Endpoint, :login,
          user: %{
            "username" => user.username,
            "password" => bad_raw_password
          }
        )
      )
      |> json_response(401)
  end
end

defmodule ApiWeb.SessionControllerTest do
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint
  import Api.Factory
  import Plug.Conn, only: [put_req_header: 3]
  use ApiWeb.ConnCase

  test "login", %{conn: conn} do
    raw_password = "password"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))
    {:ok, token, _} = Api.Auth.Guardian.encode_and_sign(user, %{}, token_type: :access)
    _resp = put_req_header(conn, "authorization", "Bearer #{token}")
    |> put_req_header("content-type", "application/json")
    |> post(Routes.session_path(Endpoint, :login, user: %{
      "username" => user.username,
      "password" => raw_password
    }))
    |> json_response(200)
  end

  test "bad login", %{conn: conn} do
    bad_raw_password = "bad_password"
    raw_password = "password"
    user = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))
    {:ok, token, _} = Api.Auth.Guardian.encode_and_sign(user, %{}, token_type: :access)
    _resp = put_req_header(conn, "authorization", "Bearer #{token}")
    |> put_req_header("content-type", "application/json")
    |> post(Routes.session_path(Endpoint, :login, user: %{
      "username" => user.username,
      "password" => bad_raw_password
    }))
    |> json_response(401)
  end
end

defmodule ApiWeb.AuthController do
  use ApiWeb, :controller

  alias Api.Auth.Session.Schema, as: SessionSchema
  alias Api.Auth.Service, as: AuthService

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    AuthService.login(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:ok, %SessionSchema{} = session}, conn) do
    conn
    |> put_resp_header("set-cookie", "id=#{session.key}")
    |> redirect(to: "/create")
  end

  defp login_reply({:error, _}, conn) do
    put_status(conn, 500)
    |> redirect(to: "/login")
  end
end

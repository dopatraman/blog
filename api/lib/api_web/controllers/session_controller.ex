defmodule ApiWeb.SessionController do
  use ApiWeb, :controller

  @auth_service Application.get_env(:api, :auth_service)

  alias Api.Auth.Guardian

  def index(_conn, _params), do: :ok

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    @auth_service.login(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> json(:ok)
  end

  defp login_reply({:error, _}, conn) do
    put_status(conn, 401)
    |> json(:error)
  end
end

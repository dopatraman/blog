defmodule Api.Auth.VerifySessionIdPipeline do
  import Plug.Conn, only: [get_req_header: 2, halt: 1, assign: 3]
  import Plug.Conn.Cookies, only: [decode: 1]
  alias Api.Auth.Service, as: AuthService
  alias Api.User.Schema, as: UserSchema

  def init(opts), do: opts

  def call(conn, _) do
    get_req_header(conn, "cookie")
    |> get_session_key()
    |> grant_access()
    |> respond(conn)
  end

  defp get_session_key([]), do: {:error, :no_request_cookie}

  defp get_session_key([cookie]) do
    case decode(cookie) do
      %{"id" => session_key} -> {:ok, session_key}
      _ -> {:error, :invalid_request_cookie}
    end
  end

  defp grant_access({:error, _} = error), do: error

  defp grant_access({:ok, session_key}), do: AuthService.attempt_access_grant(session_key)

  defp respond({:error, reason}, conn),
    do: Api.Auth.ErrorHandler.auth_error(conn, reason) |> halt()

  defp respond(%UserSchema{} = user, conn), do: assign(conn, :current_user, user)
end

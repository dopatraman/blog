defmodule Api.Auth.CurrentUser do
  import Plug.Conn
  import Guardian.Plug
  def init(opts), do: opts

  def call(conn, _opts) do
    %{"sub" => user_id} = current_claims(conn)
    assign(conn, :current_user_id, user_id)
  end
end

defmodule Api.Auth.FromVerificationPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :api,
    error_handler: Api.Auth.ErrorHandler,
    module: Api.Auth.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource
  plug Api.Auth.CurrentUser
end

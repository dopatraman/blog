defmodule Api.Auth.CurrentUser do
  import Plug.Conn
  import Guardian.Plug
  def init(opts), do: opts

  def call(conn, _opts) do
    %{"sub" => user_id} = current_claims(conn)
    assign(conn, :current_user_id, user_id)
  end
end

defmodule InspectPlug do
  import Plug.Conn
  def init(opts), do: opts

  def call(conn, _) do
    IO.inspect(conn)
  end
end

defmodule Api.Auth.VerifyAuthHeaderPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :api,
    error_handler: Api.Auth.ErrorHandler,
    module: Api.Auth.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource
  plug Api.Auth.CurrentUser
end

defmodule Api.Auth.VerifyAuthCookiePipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :api,
    error_handler: Api.Auth.ErrorHandler,
    module: Api.Auth.Guardian

  plug Guardian.Plug.VerifyCookie, exchange_from: "access"
  plug Guardian.Plug.LoadResource
  plug Api.Auth.CurrentUser
end

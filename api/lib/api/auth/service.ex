defmodule Api.Auth.Service do
  alias Api.Auth.Session.Schema, as: SessionSchema
  alias Api.Auth.Context, as: AuthContext
  alias Api.Auth.LoginCredentials

  def login(username, password) do
    LoginCredentials.of(username, password)
    |> LoginCredentials.subject()
    |> case do
      {:ok, user} -> AuthContext.insert_session(user)
      {:error, _} = error -> error
    end
  end

  def attempt_access_grant(session_key) do
    case verify_session(session_key) do
      {:ok, session} -> AuthContext.get_user_by_id(session.user_id)
      {:error, _} = error -> error
    end
  end

  defp verify_session(session_key) do
    case AuthContext.get_session(session_key) do
      nil ->
        {:error, :no_session_found}

      session ->
        if session_expired?(session), do: {:error, :session_expired}, else: {:ok, session}
    end
  end

  defp session_expired?(%SessionSchema{} = session) do
    case DateTime.compare(DateTime.utc_now(), session.expires_at) do
      :lt -> false
      :eq -> true
      :gt -> true
    end
  end
end

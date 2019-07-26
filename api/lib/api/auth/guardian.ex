defmodule Api.Auth.Guardian do
  use Guardian, otp_app: :api

  alias Api.Auth.Context, as: AuthContext

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => user_id}) do
    case AuthContext.get_user_by_id(user_id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end

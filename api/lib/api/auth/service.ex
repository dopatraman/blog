defmodule Api.Auth.Service do
  @auth_context Application.get_env(:api, :auth_context)

  alias Api.User.Schema, as: UserSchema

  def login(username, password) do
    @auth_context.get_user_by_username(username)
    |> check_password(password)
  end

  @spec check_password(UserSchema.t(), String.t()) :: {:ok, UserSchema.t()} | {:error, atom()}
  defp check_password(nil, _), do: {:error, :not_found}
  defp check_password(user, given_password) do
    case Bcrypt.verify_pass(given_password, user.password) do
      true -> {:ok, user}
      _ -> {:error, :unauthorized}
    end
  end
end

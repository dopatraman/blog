defmodule Api.Auth.LoginCredentials do
  alias Api.User.Schema, as: UserSchema
  alias Api.Auth.Context, as: AuthContext
  alias Api.Auth.LoginCredentials

  @type t() :: %LoginCredentials{
          username: String.t(),
          password: String.t()
        }

  @enforce_keys [:username, :password]
  defstruct [:username, :password]

  @spec of(String.t(), String.t()) :: LoginCredentials.t()
  def of(username, password), do: %LoginCredentials{username: username, password: password}

  @spec subject(LoginCredentials.t()) :: {:ok, UserSchema.t()} | {:error, atom()}
  def subject(%LoginCredentials{username: username, password: password}) do
    AuthContext.get_user_by_username(username)
    |> check_password(password)
  end

  @spec check_password(UserSchema.t(), String.t()) :: {:ok, UserSchema.t()} | {:error, atom()}
  defp check_password(nil, _), do: {:error, :not_found}

  defp check_password(user, raw_password) do
    case Bcrypt.verify_pass(raw_password, user.password) do
      true -> {:ok, user}
      _ -> {:error, :unauthorized}
    end
  end
end

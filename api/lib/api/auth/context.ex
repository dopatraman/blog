defmodule Api.Auth.Context do
  import Ecto.Query

  alias Api.Repo
  alias Api.User.Schema, as: UserSchema

  def get_user_by_username(username) do
    UserSchema
    |> for_username(username)
    |> Repo.one()
  end

  def get_user_by_id(user_id) do
    UserSchema
    |> for_user_id(user_id)
    |> Repo.one()
  end

  defp for_user_id(query, user_id) do
    from(u in query, where: u.id == ^user_id)
  end

  defp for_username(query, username) do
    from(u in query, where: u.username == ^username)
  end
end

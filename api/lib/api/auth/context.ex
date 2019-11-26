defmodule Api.Auth.Context do
  import Ecto.Query

  alias Api.Repo
  alias Ecto.Changeset
  alias Ecto.UUID
  alias Api.User.Schema, as: UserSchema
  alias Api.Auth.Session.Schema, as: SessionSchema

  def insert_session(%UserSchema{} = user) do
    expiration = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now(), :second) + 300)

    %SessionSchema{}
    |> Changeset.change()
    |> Changeset.put_change(:user_id, user.id)
    |> Changeset.put_change(:key, UUID.generate())
    |> Changeset.put_change(:expires_at, expiration)
    |> Repo.insert()
  end

  def get_session(key) do
    SessionSchema
    |> for_session_key(key)
    |> Repo.one()
  end

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

  defp for_session_key(query, session_key) do
    from(s in query, where: s.key == ^session_key)
  end

  defp for_user_id(query, user_id) do
    from(u in query, where: u.id == ^user_id)
  end

  defp for_username(query, username) do
    from(u in query, where: u.username == ^username)
  end
end

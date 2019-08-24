defmodule Api.User.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.User.Schema, as: UserSchema

  @type t() :: %UserSchema{
          id: integer(),
          email: String.t(),
          username: String.t(),
          password: String.t()
        }

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string
    has_many :posts, Api.Posts.Schema

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> validate_length(:password, min: 3, max: 10)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end

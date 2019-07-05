defmodule Api.User.Schema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.User.Schema, as: UserSchema

  @type t() :: %UserSchema{
          id: integer(),
          email: String.t(),
          username: String.t()
        }

  schema "users" do
    field :email, :string
    field :username, :string
    has_many :posts, Api.Post.Schema

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
  end
end

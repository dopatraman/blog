defmodule Api.Auth.Session.Schema do
  use Ecto.Schema

  alias Ecto.UUID
  alias Api.User.Schema, as: UserSchema
  alias Api.Auth.Session.Schema, as: SessionSchema

  @type t() :: %SessionSchema{
          id: integer(),
          key: UUID.t(),
          user_id: integer(),
          expires_at: DateTime.t()
        }

  schema "sessions" do
    belongs_to :user, UserSchema
    field :key, :binary_id
    field :expires_at, :utc_datetime
    timestamps()
  end
end

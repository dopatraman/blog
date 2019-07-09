defmodule Api.Post.Schema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Post.Schema, as: PostSchema
  alias Api.User.Schema, as: UserSchema

  @type t() :: %PostSchema{
          id: integer(),
          author_id: integer(),
          title: String.t(),
          content: String.t(),
          is_private: boolean()
        }

  @derive {Jason.Encoder, only: [:author_id, :content, :is_private, :title]}
  schema "posts" do
    belongs_to :author, UserSchema
    field :content, :string
    field :is_private, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:author_id, :content, :title, :is_private])
    |> validate_required([:author_id, :content, :title, :is_private])
  end
end

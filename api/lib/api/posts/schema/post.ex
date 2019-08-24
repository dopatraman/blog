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
          is_private: boolean(),
          is_processed: boolean()
        }

  @derive {Jason.Encoder, only: [:author_id, :content, :is_private, :title]}
  schema "posts" do
    belongs_to :author, UserSchema
    field :title, :string
    field :content, :string
    field :is_private, :boolean, default: false
    field :is_processed, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:author_id, :content, :title, :is_private, :is_processed])
    |> validate_required([:author_id, :content, :title, :is_private, :is_processed])
  end
end

defmodule Api.Posts.AnonymousPost do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Posts.AnonymousPost, as: AnonymousPostSchema

  @type t() :: %AnonymousPostSchema{
          id: integer(),
          post_id: String.t(),
          title: String.t(),
          content: String.t()
        }

  @derive {Jason.Encoder, only: [:content, :title, :post_id]}
  schema "anonymous_posts" do
    field :post_id, :string
    field :title, :string
    field :content, :string

    timestamps()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:post_id, :content, :title])
    |> validate_required([:post_id, :content, :title])
  end
end

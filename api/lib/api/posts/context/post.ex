defmodule Api.Post.Context do
  @behaviour Api.Post.ContextBehaviour

  alias Ecto.Changeset
  alias Api.Repo
  alias Api.Post.Schema, as: PostSchema

  def insert_post(nil, _) do
    {:error, :user_not_authorized}
  end

  def insert_post(author, params) do
    %PostSchema{}
    |> Changeset.change()
    |> Changeset.put_change(:author_id, author.id)
    |> PostSchema.changeset(params)
    |> Repo.insert()
  end

  def get_post(id) do
    #  TODO validate the id somehow, bs it's an external input
    PostSchema
    |> Repo.get(id)
  end
end

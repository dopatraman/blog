defmodule Api.Post.Context do
  @behaviour Api.Post.ContextBehaviour

  alias Ecto.Changeset
  alias Api.Repo
  alias Api.Post.Schema, as: PostSchema

  def insert_post(nil, _, _, _) do
    {:error, :user_not_authorized}
  end

  def insert_post(author, title, content, is_private) do
    %PostSchema{}
    |> Changeset.change()
    |> Changeset.put_change(:author_id, author.id)
    |> Changeset.put_change(:title, title)
    |> Changeset.put_change(:content, content)
    |> Changeset.put_change(:is_private, is_private)
    |> PostSchema.changeset(%{
      author_id: author.id,
      title: title,
      content: content,
      is_private: is_private
    })
    |> Repo.insert()
  end

  def get_post(), do: :ok
end

defmodule Api.Post.ServiceBehaviour do
  alias Api.Post.Schema, as: PostSchema

  @callback create_post(
              author_id :: integer(),
              title :: String.t(),
              content :: String.t(),
              is_private :: boolean()
            ) :: {:ok, PostSchema.t()} | {:error, atom()}

  @callback get_post_by_id(
              id :: integer(),
              author_id :: integer()
            ) :: {:ok, PostSchema.t()} | {:error, atom()}

  @callback get_posts_by_author(
              author_id :: integer(),
              is_private :: boolean()
            ) :: {:ok, [PostSchema.t()]} | {:error, atom()}
end

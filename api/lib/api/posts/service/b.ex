defmodule Api.Post.ServiceBehaviour do
  alias Api.Post.Schema, as: PostSchema

  @callback create_post(params :: term()) :: {:ok, PostSchema.t()} | {:error, atom()}

  @callback update_post(post_id :: integer(), params :: term()) ::
              {:ok, PostSchema.t()} | {:error, atom()}

  @callback get_post_by_id(author_id :: integer(), post_id :: integer()) ::
              {:ok, PostSchema.t()} | {:error, atom()}

  @callback get_posts_by_author(author_id :: integer()) :: [PostSchema.t()]
end

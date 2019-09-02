defmodule Api.Posts.ContextBehaviour do
  alias Api.Posts.Schema, as: PostSchema
  alias Api.User.Schema, as: UserSchema

  @callback insert_post(params :: term()) :: {:ok, PostSchema.t()} | {:error, atom()}

  @callback get_post(id :: integer()) :: PostSchema.t() | nil

  @callback get_all_posts(author :: UserSchema.t()) :: [PostSchema.t()] | {:error, atom()}

  @callback get_latest_post_for_author(author_id :: integer()) :: PostSchema.t() | nil
end

defmodule Api.Posts.ContextBehaviour do
  alias Api.Posts.Schema, as: PostSchema
  alias Api.User.Schema, as: UserSchema

  @callback insert_post(
              author :: UserSchema.t(),
              params :: term()
            ) :: {:ok, PostSchema.t()} | {:error, atom()}

  @callback get_post(id :: integer()) :: PostSchema.t() | nil

  @callback get_all_posts(author :: UserSchema.t()) :: [PostSchema.t()]
end

defmodule Api.Post.ContextBehaviour do
  alias Api.Post.Schema, as: PostSchema
  alias Api.User.Schema, as: UserSchema

  @callback insert_post(
              author :: UserSchema.t(),
              title :: String.t(),
              content :: String.t(),
              is_private :: boolean()
            ) :: {:ok, PostSchema.t()} | {:error, atom()}

  @callback get_post(id :: integer()) :: {:ok, PostSchema.t()} | {:error, atom()}
end

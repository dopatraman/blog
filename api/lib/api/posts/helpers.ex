defmodule Api.Posts.Helpers do

  def generate_post_id(_author_id, nil), do: nil

  def generate_post_id(author_id, post_content) do
    :crypto.hash(:sha256, "#{Integer.to_string(author_id)}#{post_content}")
    |> Base.encode64
    |> String.slice(0..20)
  end
end

defmodule Api.Posts.Helpers do
  def generate_post_id(author_id) when is_number(author_id) do
    generate_post_id(Integer.to_string(author_id))
  end

  def generate_post_id(key) when is_binary(key) do
    :crypto.hash(:sha256, "#{key}#{unix_now_string()}")
    |> Base.encode64()
    |> String.slice(0..20)
  end

  defp unix_now_string() do
    :os.system_time(:millisecond)
    |> Integer.to_string()
  end
end

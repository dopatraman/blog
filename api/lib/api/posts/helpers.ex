defmodule Api.Posts.Helpers do
  def generate_post_id(author_id) do
    :crypto.hash(:sha256, "#{Integer.to_string(author_id)}#{unix_now_string()}")
    |> Base.encode64
    |> String.slice(0..20)
  end

  defp unix_now_string() do
    :os.system_time(:millisecond)
    |> Integer.to_string
  end
end

defprotocol HTMLDisplayable do
  def from(data)
end

defimpl HTMLDisplayable, for: BitString do
  def from(string) do
    String.replace(string, "\n", "<br />")
  end
end

defimpl HTMLDisplayable, for: Api.Posts.Schema do
  def from(post) do
    %Api.Posts.Schema{post | content: HTMLDisplayable.from(post.content)}
  end
end

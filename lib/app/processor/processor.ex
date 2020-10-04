defprotocol HTMLDisplayable do
  @spec from(struct) :: String.t()
  def from(data)
end

defimpl HTMLDisplayable, for: BitString do
  def from(string) do
    String.replace(string, "\n", "<br />")
  end
end

#defimpl HTMLDisplayable, for: Api.Posts.Schema do
#  alias Api.Posts.Tokenizer
#  alias Api.Posts.Parser
#
#  def from(post) do
#    content =
#      Tokenizer.tokenize(post)
#      |> Parser.parse_content()
#      |> HTMLDisplayable.from()
#
#    %Api.Posts.Schema{post | content: "<div class=\"post-content\">" <> content <> "</div>"}
#  end
#end

defimpl HTMLDisplayable, for: Api.Posts.Parser.RootNode do
  alias Api.Posts.Parser.RootNode

  def from(%RootNode{left: nil, right: nil}), do: ""

  def from(%RootNode{left: left, right: nil}) do
    HTMLDisplayable.from(left)
  end

  def from(%RootNode{left: nil, right: right}) do
    HTMLDisplayable.from(right)
  end

  def from(%RootNode{left: left, right: right}) do
    HTMLDisplayable.from(left) <> HTMLDisplayable.from(right)
  end
end

defimpl HTMLDisplayable, for: Api.Posts.Parser.HeaderNode do
  alias Api.Posts.Parser.HeaderNode

  def from(%HeaderNode{
        level: n,
        body: node
      }) do
    "<div class=\"header-#{n}\">" <>
      HTMLDisplayable.from(node) <>
      "</div>"
  end
end

defimpl HTMLDisplayable, for: Api.Posts.Parser.CodeBlockNode do
  alias Api.Posts.Parser.CodeBlockNode

  def from(%CodeBlockNode{
        language: language,
        content: content
      }) do
    "<pre>" <>
      "<code class=\"language-#{language}\">" <>
      Enum.join(content, "\n") <>
      "</code>" <>
      "</pre>"
  end
end

defimpl HTMLDisplayable, for: Api.Posts.Parser.ParagraphNode do
  alias Api.Posts.Parser.ParagraphNode

  def from(%ParagraphNode{left: left, right: right}) do
    "<div class=\"paragraph\">" <>
      HTMLDisplayable.from(left) <>
      HTMLDisplayable.from(right) <>
      "</div>"
  end
end

defimpl HTMLDisplayable, for: Api.Posts.Parser.TextBlock do
  alias Api.Posts.Parser.TextBlock

  def from(%TextBlock{text: nil}), do: ""
  def from(%TextBlock{text: text}), do: HTMLDisplayable.from(text)
end

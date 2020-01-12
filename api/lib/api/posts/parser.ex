defmodule Api.Posts.Parser do
  alias Api.Posts.Tokenizer.Token.Header
  alias Api.Posts.Tokenizer.Token.TextNode
  alias Api.Posts.Parser.ASTNode
  alias Api.Posts.Parser.RootNode
  alias Api.Posts.Parser.TextBlock
  alias Api.Posts.Parser.ParagraphNode
  alias Api.Posts.Parser.Header, as: HeaderParser

  @spec parse_content([Token.t()]) :: ASTNode.t()
  def parse_content([]), do: nil

  @spec parse_content([Token.t()]) :: ASTNode.t()
  def parse_content([line_tokens | rest]) do
    %RootNode{
      left: parse_line(line_tokens),
      right: parse_content(rest)
    }
  end

  @spec parse_line([Token.t()]) :: ASTNode.t()
  defp parse_line([]), do: %RootNode{}

  @spec parse_line([Token.t()]) :: ASTNode.t()
  defp parse_line([%Header{} | _rest] = tokens), do: HeaderParser.parse(tokens)

  @spec parse_line([Token.t()]) :: ASTNode.t()
  defp parse_line([%TextNode{text: text} | rest]),
    do: %ParagraphNode{
      left: %TextBlock{text: text},
      right: parse_line(rest)
    }
end

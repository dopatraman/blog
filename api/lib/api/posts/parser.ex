defmodule Api.Posts.Parser do
  alias Api.Posts.Tokenizer.Token.Header
  alias Api.Posts.Tokenizer.Token.BackTick
  alias Api.Posts.Tokenizer.Token.TextNode
  alias Api.Posts.Parser.ASTNode
  alias Api.Posts.Parser.RootNode
  alias Api.Posts.Parser.TextBlock
  alias Api.Posts.Parser.ParagraphNode
  alias Api.Posts.Parser.Header, as: HeaderParser
  alias Api.Posts.Parser.Fence, as: FenceParser
  alias Api.Posts.Parser.Fence.AccumulatingState

  @spec parse_content([Token.t()]) :: ASTNode.t()
  def parse_content([]), do: nil

  @spec parse_content([Token.t()]) :: ASTNode.t()
  def parse_content([line_tokens | rest]) do
    case parse_line(line_tokens) do
      %AccumulatingState{} = parser_state ->
        parse_content(parser_state, rest)

      _ = node ->
        %RootNode{
          left: node,
          right: parse_content(rest)
        }
    end
  end

  def parse_content(%AccumulatingState{} = parser_state, [line_tokens | rest]) do
    case parse_line(parser_state, line_tokens) do
      %AccumulatingState{} = new_parser_state ->
        parse_content(new_parser_state, rest)

      _ = node ->
        %RootNode{
          left: node,
          right: parse_content(rest)
        }
    end
  end

  @spec parse_line([Token.t()]) :: ASTNode.t()
  defp parse_line([]), do: %RootNode{}

  @spec parse_line([Token.t()]) :: ASTNode.t()
  defp parse_line([%Header{} | _rest] = tokens), do: HeaderParser.parse(tokens)

  @spec parse_line([Token.t()]) :: AccumulatingState.t()
  defp parse_line([%BackTick{}, %BackTick{}, %BackTick{} | _rest] = tokens),
    do: FenceParser.parse(tokens)

  @spec parse_line(AccumulatingState.t(), [Token.t()]) :: ASTNode.t()
  defp parse_line(%AccumulatingState{} = parser_state, tokens),
    do: FenceParser.parse(parser_state, tokens)

  @spec parse_line([Token.t()]) :: ASTNode.t()
  defp parse_line([%TextNode{text: text} | rest]),
    do: %ParagraphNode{
      left: %TextBlock{text: text},
      right: parse_line(rest)
    }
end

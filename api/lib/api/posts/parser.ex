defmodule Api.Posts.Parser do
  alias Api.Posts.Tokenizer.Token.Header
  alias Api.Posts.Parser.RootNode
  alias Api.Posts.Parser.Header, as: HeaderParser

  def parse_content([]), do: nil

  def parse_content([line_tokens | rest]) do
    %RootNode{
      left: parse_line(line_tokens),
      right: parse_content(rest)
    }
  end

  defp parse_line([%Header{} | _rest] = tokens), do: HeaderParser.parse(tokens)
end

defmodule Api.Posts.Parser.Fence.AccumulatingState do
  @type t() :: %{
          language: String.t(),
          content: list(String.t())
        }

  defstruct language: nil,
            content: []
end

defmodule Api.Posts.Parser.Fence do
  import Api.Posts.Tokenizer.Token, only: [text: 1]
  alias Api.Posts.Parser.Fence.AccumulatingState
  alias Api.Posts.Tokenizer.Token
  alias Api.Posts.Tokenizer.Token.BackTick
  alias Api.Posts.Tokenizer.Token.TextNode
  alias Api.Posts.Parser.CodeBlockNode
  require IEx

  def parse([%BackTick{}, %BackTick{}, %BackTick{}]) do
    %AccumulatingState{}
  end

  def parse([%BackTick{}, %BackTick{}, %BackTick{}, %TextNode{text: language}]) do
    %AccumulatingState{language: language}
  end

  def parse(%AccumulatingState{} = parser_state, tokens) do
    parse_(parser_state, "", tokens)
  end

  defp parse_(%AccumulatingState{} = parser_state, "", []) do
    parser_state
  end

  defp parse_(%AccumulatingState{language: language, content: content}, "", [
         %BackTick{},
         %BackTick{},
         %BackTick{} | _rest
       ]) do
    %CodeBlockNode{language: language, content: content}
  end

  defp parse_(%AccumulatingState{content: content} = parser_state, int_state, []) do
    Map.put(parser_state, :content, content ++ [int_state])
  end

  defp parse_(%AccumulatingState{language: language, content: content}, int_state, [
         %BackTick{},
         %BackTick{},
         %BackTick{} | _rest
       ]) do
    %CodeBlockNode{language: language, content: content ++ [int_state]}
  end

  defp parse_(%AccumulatingState{} = parser_state, int_state, [token | rest]) do
    parse_(parser_state, int_state <> text(token), rest)
  end

  # defp reduce_tokens_to_string(tokens) do
  #   tokens
  #   |> Enum.map(fn x -> text(x) end)
  #   |> Enum.join(" ")
  # end

  # def parse([%BackTick{}, %BackTick{}, %BackTick{} | rest]) do
  #   parse(%AccumulatingState{content: []}, "", rest)
  # end

  # def parse(%AccumulatingState{} = parser_state, tokens) do
  #   parse(parser_state, "", tokens)
  # end

  # def parse(%AccumulatingState{} = parser_state, "", []) do
  #   parser_state
  # end

  # def parse(%AccumulatingState{content: content}, int_state, []) do
  #   %AccumulatingState{content: content ++ [int_state]}
  # end

  # def parse(%AccumulatingState{content: content}, "", [%BackTick{}, %BackTick{}, %BackTick{} | _rest]) do
  #   %CodeBlockNode{content: content}
  # end

  # def parse(%AccumulatingState{content: content}, int_state, [%BackTick{}, %BackTick{}, %BackTick{} | _rest]) do
  #   %CodeBlockNode{content: content ++ [int_state]}
  # end

  # def parse(%AccumulatingState{} = parser_state, int_state, [token | rest]) do
  #   parse(parser_state, int_state <> text(token), rest)
  # end
end

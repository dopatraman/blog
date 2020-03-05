defmodule Api.Posts.Parser.Header.LevelCountingState do
  @type t() :: %{
          level: integer()
        }
  defstruct level: 0
end

defmodule Api.Posts.Parser.Header.ContentAcceptingState do
  @type t() :: %{
          level: integer(),
          content: String.t()
        }

  defstruct level: 0,
            content: nil
end

defmodule Api.Posts.Parser.Header do
  import Api.Posts.Tokenizer.Token, only: [text: 1]
  alias Api.Posts.Tokenizer.Token
  alias Api.Posts.Tokenizer.Token.Header
  alias Api.Posts.Parser.Header.LevelCountingState
  alias Api.Posts.Parser.Header.ContentAcceptingState
  alias Api.Posts.Parser.{HeaderNode, TextBlock}

  def parse([%Header{} | rest]), do: parse(%LevelCountingState{level: 1}, rest)

  def parse(%LevelCountingState{level: 6}, tokens),
    do: parse(%ContentAcceptingState{level: 6}, tokens)

  def parse(%LevelCountingState{level: n}, [%Header{} | rest]),
    do: parse(%LevelCountingState{level: n + 1}, rest)

  def parse(%LevelCountingState{level: n}, tokens),
    do: parse(%ContentAcceptingState{level: n}, tokens)

  def parse(%ContentAcceptingState{level: n}, tokens),
    do: %HeaderNode{
      level: n,
      body: %TextBlock{text: reduce_tokens_to_string(tokens)}
    }

  @spec reduce_tokens_to_string([Token.t()]) :: String.t()
  defp reduce_tokens_to_string(tokens) do
    tokens
    |> Enum.map(fn x -> text(x) end)
    # This is not efficient
    |> Enum.reduce(fn x, acc -> acc <> x end)
  end
end

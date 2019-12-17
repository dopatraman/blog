defmodule Api.Posts.Tokenizer do
  alias Api.Posts.Tokenizer.Token.{
    BackTick,
    BlockQuoteCaret,
    Bullet,
    Header,
    Ordinal,
    Dot,
    TextNode
  }

  alias Api.Posts.Schema, as: PostSchema

  def tokenize(%PostSchema{content: content}), do: tokenize(content)

  def tokenize(content) when is_binary(content) do
    lines(content)
    |> Enum.map(fn line -> scan(line) end)
  end

  # [%LineStruct]? LineString protocol?
  @spec lines(String.t()) :: [[Token.t()]]
  def lines(content) when is_binary(content), do: String.split(content, "\n", trim: true)

  @spec scan(String.t()) :: [Token.t()]
  def scan(line) when is_binary(line), do: scan_(line, {[], ""}) |> Enum.reverse()

  @spec scan_(String.t(), {[Token.t()], binary()}) :: [Token.t()]
  def scan_(line, {acc, fragments}) when is_binary(line) do
    case token(line, fragments) do
      {nil, "", f} -> [%TextNode{text: f} | acc]
      {nil, rest, f} -> scan_(rest, {acc, f})
      {t, "", ""} -> [t | acc]
      {t, "", f} -> [t | [%TextNode{text: f} | acc]]
      {t, rest, "" = f} -> scan_(rest, {[t | acc], f})
      {t, rest, f} -> scan_(rest, {[t | [%TextNode{text: f} | acc]], ""})
    end
  end

  @spec token(String.t(), binary()) :: {Token.t(), String.t()}
  def token(<<c::utf8, rest::binary>>, fragments) do
    case c do
      ?# -> {%Header{}, rest, fragments}
      ?> -> {%BlockQuoteCaret{}, rest, fragments}
      ?` -> {%BackTick{}, rest, fragments}
      ?. -> {%Dot{}, rest, fragments}
      x when x in [?-, ?*] -> {%Bullet{}, rest, fragments}
      _ = cp -> {nil, rest, fragments <> <<cp>>}
    end
  end
end

defprotocol Api.Posts.Tokenizer.Token do
  @type t() :: any()

  @spec text(Token.t()) :: String.t()
  def text(token)
end

defmodule Api.Posts.Tokenizer.Token.BackTick do
  @type t() :: %{}
  defstruct []

  defimpl Api.Posts.Tokenizer.Token do
    def text(_), do: "`"
  end
end

defmodule Api.Posts.Tokenizer.Token.BlockQuoteCaret do
  @type t() :: %{}
  defstruct []

  defimpl Api.Posts.Tokenizer.Token do
    def text(_), do: ">"
  end
end

defmodule Api.Posts.Tokenizer.Token.Bullet do
  @type t() :: %{}
  defstruct []

  defimpl Api.Posts.Tokenizer.Token do
    def text(_), do: "*"
  end
end

defmodule Api.Posts.Tokenizer.Token.Header do
  @type t() :: %{}
  defstruct []

  defimpl Api.Posts.Tokenizer.Token do
    def text(_), do: "#"
  end
end

defmodule Api.Posts.Tokenizer.Token.Ordinal do
  @type t() :: %{
          identifier: String.t()
        }
  defstruct identifier: nil

  defimpl Api.Posts.Tokenizer.Token do
    def text(token), do: token.identifier
  end
end

defmodule Api.Posts.Tokenizer.Token.Dot do
  @type t() :: %{}
  defstruct []

  defimpl Api.Posts.Tokenizer.Token do
    def text(_), do: "."
  end
end

defmodule Api.Posts.Tokenizer.Token.TextNode do
  @type t() :: %{
          text: String.t()
        }
  defstruct text: nil

  defimpl Api.Posts.Tokenizer.Token do
    def text(token), do: token.text
  end
end

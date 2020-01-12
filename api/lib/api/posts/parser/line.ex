defmodule Api.Posts.Parser.Line.InitializedState do
  alias Api.Posts.Tokenizer.Token

  @type t() :: %{
          token: Token.t()
        }
  defstruct token: nil
end

defmodule Api.Posts.Parser.Line do
  alias Api.Posts.Parser.Line.InitializedState

  def init(token), do: %InitializedState{token: token}

  def parse(%InitializedState{token: initial_token}, tokens) do
    :wip
  end
end

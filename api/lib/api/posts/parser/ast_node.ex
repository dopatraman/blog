# This protocol is not being used. Delete.
defprotocol Api.Posts.Parser.ASTNode do
  @type t() :: %{
          left: Api.Posts.Parser.ASTNode.t(),
          right: Api.Posts.Parser.ASTNode.t()
        }
end

defmodule Api.Posts.Parser.RootNode do
  defstruct left: nil,
            right: nil

  defimpl Api.Posts.Parser.ASTNode do
  end
end

defmodule Api.Posts.Parser.HeaderNode do
  @type t() :: %{
          level: integer(),
          body: Api.Posts.Parser.ASTNode.t()
        }
  defstruct level: nil,
            body: nil

  defimpl Api.Posts.Parser.ASTNode do
  end
end

defmodule Api.Posts.Parser.BlockQuoteNode do
end

defmodule Api.Posts.Parser.ParagraphNode do
  @type t() :: %{
          left: TextBlock.t(),
          right: ASTNode.t()
        }
  defstruct left: nil,
            right: nil

  defimpl Api.Posts.Parser.ASTNode do
  end
end

defmodule Api.Posts.Parser.TextBlock do
  @type t() :: %{
          text: String.t()
        }
  defstruct text: nil

  defimpl Api.Posts.Parser.ASTNode do
  end
end

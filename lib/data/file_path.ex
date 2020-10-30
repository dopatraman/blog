defmodule Blog.Data.FilePath do
  alias Blog.Data.FilePath

  @type t() :: %FilePath{
          name: String.t(),
          children: list(t())
        }
  @type mapt() :: %{
          required(:name) => String.t(),
          required(:type) => :file | :dir,
          optional(:children) => [mapt()]
        }

  defstruct name: nil,
            children: []

  @spec read_directory(String.t()) :: FilePath.t()
  def read_directory(directory_name) do
    Path.join(directory_name, "/*")
    |> Path.wildcard()
    |> case do
      [] ->
        %FilePath{
          name: directory_name,
          children: []
        }

      files ->
        %FilePath{
          name: directory_name,
          children:
            Enum.map(
              files,
              fn f -> read_directory(f) end
            )
        }
    end
  end
end

defimpl HTMLDisplayable, for: Blog.Data.FilePath do
  alias Blog.Data.FilePath

  def from(%FilePath{name: name, children: []}) do
    "<a href=\"/post/#{Base.encode64(name)}\" class=\"post\">#{Path.basename(name)}</a>"
  end

  def from(%FilePath{name: name, children: children}) do
    root = fn content -> "<div class=\"post-parent\">" <> content <> "</div>" end
    parent_node = "<div class=\"parent-name\">#{Path.basename(name)}/</div>"
    child_nodes = Enum.map(children, fn c -> HTMLDisplayable.from(c) end)
    Enum.join([parent_node | child_nodes], "") |> root.()
  end
end

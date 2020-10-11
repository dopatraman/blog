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

  @spec as_map(FilePath.t()) :: mapt()
  def as_map(f) do
    children = Enum.map(f.children, fn child -> as_map(child) end)
    type = if length(children) == 0, do: :file, else: :dir

    %{
      "name" => f.name,
      "type" => type,
      "children" => children
    }
  end
end

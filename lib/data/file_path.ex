defmodule Blog.Data.FilePath do
  alias Blog.Data.FilePath

  @type t() :: %FilePath{
          name: String.t(),
          children: list(t())
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

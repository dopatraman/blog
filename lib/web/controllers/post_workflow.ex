defmodule Blog.Web.PostWorkflow do
  @moduledoc """
  This module contains all post related workflows
  """
  alias Blog.Data.FilePath
  alias Blog.App.Processor

  @spec serve_dir() :: FilePath.t()
  def serve_dir() do
    FilePath.read_directory(Application.get_env(:blog, :post_dir))
  end

  @spec serve_post(String.t()) :: {:ok, String.t()} | {:error, atom()} | {:error, nil}
  def serve_post(post_path) do
    case File.exists?(post_path) && is_content?(post_path) do
      true -> File.read(post_path) |> Processor.process_content()
      false -> {:error, nil}
    end
  end

  def is_content?(p) do
    full_p = Path.expand(p)

    Path.relative_to(full_p, Application.get_env(:blog, :post_dir))
    |> byte_size()
    |> case do
      x when x < byte_size(full_p) -> true
      _ -> false
    end
  end
end

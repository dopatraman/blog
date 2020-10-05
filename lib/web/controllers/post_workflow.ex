defmodule Blog.Web.PostWorkflow do
  @moduledoc """
  This module contains all post related workflows
  """
  alias Api.Posts.Tokenizer
  alias Api.Posts.Parser

  @spec serve_post(String.t()) :: {:ok, String.t()} | {:error, atom()} | {:error, nil}
  def serve_post(post_path) do
    case File.exists?(post_path) do
      true -> File.read(post_path) |> process_content()
      false -> {:error, nil}
    end
  end

  @spec process_content({:ok, String.t()}) :: {:ok, String.t()} | {:error, atom}
  def process_content({:ok, content}) do
    html =
      Tokenizer.tokenize(content)
      |> Parser.parse_content()
      |> HTMLDisplayable.from()

    {:ok, html}
  end

  def process_content(e = {:error, _}), do: e
end

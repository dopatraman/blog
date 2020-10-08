defmodule Blog.App.Processor do
  @moduledoc """
  This module is the facade for markup processing
  """
  alias Api.Posts.Tokenizer
  alias Api.Posts.Parser

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


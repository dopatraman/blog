defmodule Blog.Web.GitHookController do
  @moduledoc """
  This controller covers the receive hook interface
  """
  alias Blog.App.SourceService

  def source_post_receive(token) do
    # auth token
    case auth(token) do
      :ok -> update_from_source
      _ -> {401, "Unauthorized"}
    end
  end

  defp update_from_source do
    case SourceService.SourceService.update_local_posts_from_source() do
      :ok -> {200, "Thanks"}
      :error -> {400, "Something went wrong."}
    end
  end

  defp auth(token) do
    :ok
  end
end

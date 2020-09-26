defmodule Blog.Web.GitHookController do
  @moduledoc """
  This controller covers the receive hook interface
  """
  alias Blog.App.SourceService

  def source_post_receive(%{"token" => token}) do
    # auth token
    case auth(token) do
      :ok -> update_from_source
      _ -> :unauthorized
    end
  end

  defp update_from_source do
    case SourceService.update_local_posts_from_source() do
      :ok -> :success
      _ -> :failure
    end
  end

  defp auth(token) do
    :ok
  end
end

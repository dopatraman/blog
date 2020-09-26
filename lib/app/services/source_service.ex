defmodule Blog.App.SourceService do
  @moduledoc """
  This module contains git logic for fetching posts
  """

  def update_local_posts_from_source do
    repo_url = Application.get_env(:blog, :post_repo_url)
    local_dir = Application.get_env(:blog, :local_content_dir)

    Path.join(local_dir, ".git/*")
    |> Path.wildcard()
    |> length()
    |> case do
      0 -> git_clone(repo_url, local_dir)
      _ -> git_pull(local_dir)
    end
  end

  defp git_clone(remote_url, local_path) do
    case System.cmd("git", ["clone", remote_url, local_path]) do
      {_, 0} -> :ok
      _ -> :clone_error
    end
  end

  defp git_pull(local_path) do
    case System.cmd("git", ["pull"], cd: local_path) do
      {_, 0} -> :ok
      _ -> :pull_error
    end
  end
end

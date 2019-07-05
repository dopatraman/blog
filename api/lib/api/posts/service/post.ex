defmodule Api.Post.Service do
  @behaviour Api.Post.ServiceBehaviour

  def create_post(author_id, title, content, is_private) do

  end

  def get_post_by_id(id, author_id) do

  end

  def get_posts_by_author(author_id, true = is_private) do

  end

  def get_posts_by_author(author_id, false = is_private) do

  end
end

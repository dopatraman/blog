defmodule Api.Post.ServiceTest do
  use ApiWeb.ConnCase
  import Api.Factory
  alias Api.Repo

  @post_service Application.get_env(:api, :post_service)

  describe "create_post/4" do
    test "should create a post" do
      user = insert(:user)
      {:ok, post} = @post_service.create_post(user.id, "My Post", "My Content", false)

      assert post.author_id == user.id
      assert post.title == "My Post"
      assert post.content == "My Content"
      assert !post.is_private
      assert !is_nil(post.id)
    end
  end

  describe "get_post_by_id/1" do
    test "should get a post" do
      control = insert(:post)

      post = @post_service.get_post_by_id(control.id) |> Repo.preload(:author)

      assert post.id == control.id
      assert post.title == control.title
      assert post.author.id == control.author.id
    end
  end
end

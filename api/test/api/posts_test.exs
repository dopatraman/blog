defmodule Api.Post.ServiceTest do
  use ApiWeb.ConnCase
  import Api.Factory
  alias Api.Repo

  @post_service Application.get_env(:api, :post_service)

  describe "create_post/4" do
    test "should create a post" do
      user = insert(:user)

      {:ok, post} =
        @post_service.create_post(%{
          "author_id" => user.id,
          "title" => "My Post",
          "content" => "My Content",
          "is_private" => false
        })

      assert post.author_id == user.id
      assert post.title == "My Post"
      assert post.content == "My Content"
      assert !post.is_private
      assert !is_nil(post.id)
    end

    test "should return an error for a non-existent user" do
      {:error, _} =
        @post_service.create_post(%{
          "author_id" => 1,
          "title" => "Hack 4 LuLz",
          "content" => "Power Overwhelming",
          "is_private" => false
        })
    end
  end

  describe "get_post_by_id/1" do
    test "should get a post" do
      control = insert(:post)

      {:ok, post} = @post_service.get_post_by_id(control.id)
      post = Repo.preload(post, :author)

      assert post.id == control.id
      assert post.title == control.title
      assert post.author.id == control.author.id
    end

    test "should return nil for a non-existent post" do
      {:error, :does_not_exist} = @post_service.get_post_by_id(100)
    end
  end
end

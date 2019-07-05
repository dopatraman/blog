defmodule Api.Post.ServiceTest do
  use ApiWeb.ConnCase
  import Api.Factory

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
end

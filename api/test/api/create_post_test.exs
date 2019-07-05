defmodule Api.Post.ServiceTest do
  use ApiWeb.ConnCase

  alias Api.Post.Schema, as: PostSchema

  @post_service Application.get_env(:api, :post_service)

  describe "create_post/4" do
    test "should create a post" do
      {:ok,
       %PostSchema{
         id: id,
         title: "My Post",
         content: "My Content"
       }} = @post_service.create_post(3, "My Post", "My Content", false)

      assert !is_nil(id)
    end
  end
end

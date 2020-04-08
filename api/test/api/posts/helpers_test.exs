defmodule Api.Posts.HelpersTest do
  use ExUnit.Case
  alias Api.Posts.Helpers

  describe "generate_post_id/2" do
    test "should generate a post id" do
      post_id = Helpers.generate_post_id(1)
      assert (is_binary(post_id) and !is_nil(post_id))
    end
  end
end

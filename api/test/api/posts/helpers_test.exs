defmodule Api.Posts.HelpersTest do
  use ExUnit.Case
  alias Api.Posts.Helpers

  describe "generate_post_id/2" do
    test "should generate a post id" do
      assert Helpers.generate_post_id(1, "My Content") == "PQ4ktvMvGMnpPSQAN2VwU"
    end
  end
end

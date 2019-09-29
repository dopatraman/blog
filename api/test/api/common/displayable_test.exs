defmodule Api.Common.DisplayableTest do
  use ExUnit.Case

  alias Api.Posts.Schema, as: PostSchema

  test "should convert newline chars to br elements" do
    assert HTMLDisplayable.from("hello\nthere") == "hello<br />there"
  end

  test "should convert post content to displayable content" do
    post = %PostSchema{
      title: "My\nTitle",
      content: "My\nContent"
    }
    new_post = HTMLDisplayable.from(post)
    assert new_post.title == post.title
    assert new_post.content == "My<br />Content"
  end
end
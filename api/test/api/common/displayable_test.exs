defmodule Api.Common.DisplayableTest do
  use ExUnit.Case

  alias Api.Posts.Schema, as: PostSchema
  alias Api.Posts.Parser.RootNode
  alias Api.Posts.Parser.HeaderNode
  alias Api.Posts.Parser.ParagraphNode
  alias Api.Posts.Parser.TextBlock

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

    assert new_post.content ==
      "<div class=\"post-content\"><div class=\"paragraph\">My</div><div class=\"paragraph\">Content</div></div>"
  end

  test "should render a text block" do
    assert HTMLDisplayable.from(%TextBlock{text: "hello"}) == "hello"
    assert HTMLDisplayable.from(%TextBlock{text: nil}) == ""
  end

  test "should render a header node" do
    header = %HeaderNode{level: 4, body: %TextBlock{text: "hello"}}
    assert HTMLDisplayable.from(header) == "<div class=\"header-4\">hello</div>"
  end

  test "should render a root node" do
    root = %RootNode{
      left: %HeaderNode{level: 2, body: %TextBlock{text: "level 2"}},
      right: %RootNode{
        left: %ParagraphNode{left: %TextBlock{text: "body"}, right: %RootNode{}},
        right: %RootNode{
          left: %HeaderNode{level: 3, body: %TextBlock{text: "level 3"}},
          right: %ParagraphNode{left: %TextBlock{text: "body 3"}, right: %RootNode{}}
        }
      }
    }

    assert HTMLDisplayable.from(root) == "<div class=\"header-2\">level 2</div><div class=\"paragraph\">body</div><div class=\"header-3\">level 3</div><div class=\"paragraph\">body 3</div>"
  end
end

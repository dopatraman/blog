defmodule Api.Posts.ParserTest do
  use ExUnit.Case

  alias Api.Posts.Parser

  alias Api.Posts.Parser.{
    RootNode,
    HeaderNode,
    TextBlock
  }

  alias Api.Posts.Tokenizer.Token.{
    Header,
    TextNode
  }

  test "should parse a header:1" do
    line = [%Header{}, %TextNode{text: "Hello"}]

    %RootNode{
      left: %HeaderNode{
        level: 1,
        body: %TextBlock{text: "Hello"}
      },
      right: nil
    } = Parser.parse_content([line])
  end

  test "should parse two header lines" do
    line = [%Header{}, %TextNode{text: "Hello"}]
    line2 = [%Header{}, %Header{}, %TextNode{text: "Hello Two"}]

    %RootNode{
      left: %HeaderNode{
        level: 1,
        body: %TextBlock{text: "Hello"}
      },
      right: %RootNode{
        left: %HeaderNode{
          level: 2,
          body: %TextBlock{text: "Hello Two"}
        },
        right: nil
      }
    } = Parser.parse_content([line, line2])
  end
end

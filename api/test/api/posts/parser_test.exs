defmodule Api.Posts.ParserTest do
  use ExUnit.Case

  alias Api.Posts.Parser

  alias Api.Posts.Parser.{
    RootNode,
    HeaderNode,
    CodeBlockNode,
    TextBlock
  }

  alias Api.Posts.Tokenizer.Token.{
    Header,
    BackTick,
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

  test "should parse a code block without language" do
    line = [%BackTick{}, %BackTick{}, %BackTick{}]
    line2 = [%TextNode{text: "var a = 1;"}]
    line3 = [%BackTick{}, %BackTick{}, %BackTick{}]

    %RootNode{
      left: %CodeBlockNode{language: nil, content: ["var a = 1;"]},
      right: nil
    } = Parser.parse_content([line, line2, line3])
  end

  test "should parse a code block with language" do
    line = [%BackTick{}, %BackTick{}, %BackTick{}, %TextNode{text: "javascript"}]
    line2 = [%TextNode{text: "var a = 1;"}]
    line3 = [%BackTick{}, %BackTick{}, %BackTick{}]

    %RootNode{
      left: %CodeBlockNode{language: "javascript", content: ["var a = 1;"]},
      right: nil
    } = Parser.parse_content([line, line2, line3])
  end

  test "should parse a multi-line code block without language" do
    line = [%BackTick{}, %BackTick{}, %BackTick{}]
    line2 = [%TextNode{text: "var a = 1;"}]
    line3 = [%TextNode{text: "var b = 1;"}]
    line4 = [%TextNode{text: "var c = a + b;"}]
    line5 = [%BackTick{}, %BackTick{}, %BackTick{}]

    %RootNode{
      left: %CodeBlockNode{language: nil, content: ["var a = 1;", "var b = 1;", "var c = a + b;"]},
      right: nil
    } = Parser.parse_content([line, line2, line3, line4, line5])
  end

  test "should parse a multi-line code block with language" do
    line = [%BackTick{}, %BackTick{}, %BackTick{}, %TextNode{text: "javascript"}]
    line2 = [%TextNode{text: "var a = 1;"}]
    line3 = [%TextNode{text: "var b = 1;"}]
    line4 = [%TextNode{text: "var c = a + b;"}]
    line5 = [%BackTick{}, %BackTick{}, %BackTick{}]

    %RootNode{
      left: %CodeBlockNode{
        language: "javascript",
        content: ["var a = 1;", "var b = 1;", "var c = a + b;"]
      },
      right: nil
    } = Parser.parse_content([line, line2, line3, line4, line5])
  end

  test "should parse a code block that ends on the same line as content" do
    line = [%BackTick{}, %BackTick{}, %BackTick{}, %TextNode{text: "javascript"}]
    line2 = [%TextNode{text: "var a = 1;"}, %BackTick{}, %BackTick{}, %BackTick{}]

    %RootNode{
      left: %CodeBlockNode{language: "javascript", content: ["var a = 1;"]},
      right: nil
    } = Parser.parse_content([line, line2])
  end
end

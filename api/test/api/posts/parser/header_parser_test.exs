defmodule Api.Posts.Parser.HeaderParserTest do
  use ExUnit.Case
  alias Api.Posts.Tokenizer.Token.Header, as: HeaderToken
  alias Api.Posts.Tokenizer.Token.TextNode, as: TextNodeToken
  alias Api.Posts.Parser.Header, as: HeaderParser
  alias Api.Posts.Parser.{HeaderNode, TextBlock}

  test "should return a level 1 HeaderNode" do
    tokens = [%HeaderToken{}, %TextNodeToken{text: " Hello"}]

    %HeaderNode{
      level: 1,
      body: %TextBlock{text: " Hello"}
    } = HeaderParser.parse(tokens)
  end

  test "should return a level 2 HeaderNode" do
    tokens = [%HeaderToken{}, %HeaderToken{}, %TextNodeToken{text: " Hello"}]

    %HeaderNode{
      level: 2,
      body: %TextBlock{text: " Hello"}
    } = HeaderParser.parse(tokens)
  end

  test "should return a level 3 HeaderNode" do
    tokens = [%HeaderToken{}, %HeaderToken{}, %HeaderToken{}, %TextNodeToken{text: " Hello"}]

    %HeaderNode{
      level: 3,
      body: %TextBlock{text: " Hello"}
    } = HeaderParser.parse(tokens)
  end

  test "should return a level 4 HeaderNode" do
    tokens = [
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %TextNodeToken{text: " Hello"}
    ]

    %HeaderNode{
      level: 4,
      body: %TextBlock{text: " Hello"}
    } = HeaderParser.parse(tokens)
  end

  test "should return a level 5 HeaderNode" do
    tokens = [
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %TextNodeToken{text: " Hello"}
    ]

    %HeaderNode{
      level: 5,
      body: %TextBlock{text: " Hello"}
    } = HeaderParser.parse(tokens)
  end

  test "should return a level 6 HeaderNode" do
    tokens = [
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %TextNodeToken{text: " Hello"}
    ]

    %HeaderNode{
      level: 6,
      body: %TextBlock{text: " Hello"}
    } = HeaderParser.parse(tokens)
  end

  test "should return a level 6 HeaderNode + excess" do
    tokens = [
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %HeaderToken{},
      %TextNodeToken{text: " Hello"}
    ]

    %HeaderNode{
      level: 6,
      body: %TextBlock{text: "# Hello"}
    } = HeaderParser.parse(tokens)
  end
end

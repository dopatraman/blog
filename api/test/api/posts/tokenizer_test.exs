defmodule Api.Posts.Tokenizer.TokenizerTest do
  use ExUnit.Case

  alias Api.Posts.Tokenizer

  alias Api.Posts.Tokenizer.Token.{
    BackTick,
    Blank,
    BlockQuoteCaret,
    Bullet,
    Header,
    Ordinal,
    Dot,
    TextNode
  }

  test "should return a Header token" do
    {%Header{}, " Hello", ""} = Tokenizer.token("# Hello", "")
  end

  test "should return a BlockQuote caret" do
    {%BlockQuoteCaret{}, " Hey there", ""} = Tokenizer.token("> Hey there", "")
  end

  test "should return a Bullet token" do
    {%Bullet{}, " hi", ""} = Tokenizer.token("- hi", "")

    {%Bullet{}, " works with asterisks too", ""} =
      Tokenizer.token("* works with asterisks too", "")
  end

  test "should return a BackTick token" do
    {%BackTick{}, "code`", ""} = Tokenizer.token("`code`", "")
  end

  test "should return a text fragment" do
    {nil, "orem ipsum", "l"} = Tokenizer.token("lorem ipsum", "")
    {nil, "rem ipsum", "lo"} = Tokenizer.token("orem ipsum", "l")
    {nil, "", "lorem ipsum"} = Tokenizer.token("m", "lorem ipsu")
  end

  test "should return a Dot token" do
    {%Dot{}, "1", ""} = Tokenizer.token(".1", "")
  end

  test "should return a text node" do
    [%TextNode{text: "Hello "}, _] = Tokenizer.scan("Hello #")
  end

  test "should return a header and text node" do
    [%Header{}, %TextNode{text: " Title"}] = Tokenizer.scan("# Title")
    [%Header{}, %Header{}, %Header{}, %TextNode{text: " Title"}] = Tokenizer.scan("### Title")
  end

  test "should return a block caret and text node" do
    [%BlockQuoteCaret{}, %TextNode{text: " Hello"}] = Tokenizer.scan("> Hello")
  end

  test "should return a bullet and text node" do
    [%Bullet{}, %TextNode{text: " Item 1"}] = Tokenizer.scan("- Item 1")
  end

  test "should return a backtick and text node" do
    [%BackTick{}, %TextNode{text: "code"}] = Tokenizer.scan("`code")
    [%BackTick{}, %TextNode{text: "code"}, %BackTick{}] = Tokenizer.scan("`code`")
  end

  test "should return a Dot and Text" do
    [%Dot{}, %TextNode{text: "1"}] = Tokenizer.scan(".1")
  end
end

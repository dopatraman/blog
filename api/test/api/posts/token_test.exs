defmodule Api.Posts.Tokenizer.TokenTests do
  use ExUnit.Case

  alias Api.Posts.Tokenizer.Token

  alias Api.Posts.Tokenizer.Token.{
    BackTick,
    BlockQuoteCaret,
    Bullet,
    Header,
    TextNode
  }

  test "should return a backtick string" do
    token = %BackTick{}
    assert Token.text(token) == "`"
  end

  test "should return a block quote string" do
    token = %BlockQuoteCaret{}
    assert Token.text(token) == ">"
  end

  test "should return a bullet string" do
    token = %Bullet{}
    assert Token.text(token) == "*"
  end

  test "should return a header token string" do
    token = %Header{}
    assert Token.text(token) == "#"
  end

  test "should return a text block" do
    token = %TextNode{text: "test"}
    assert Token.text(token) == "test"
  end
end

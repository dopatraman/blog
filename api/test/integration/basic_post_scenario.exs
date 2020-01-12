defmodule Api.IntegrationTests.BasicPostTest do
  use ExUnit.Case, async: true
  use Api.DataCase

  import Api.Factory

  test "should render a post properly e2e" do
    raw_password = "pwnage"
    author = insert(:user, password: Bcrypt.hash_pwd_salt(raw_password))
    post = insert(:post, author: author, title: "Foo", content: "## This is a header\r\nLet's talk about content.")

    rendered_post = HTMLDisplayable.from(post)
    assert rendered_post.content == "<div class=\"post-content\"><div class=\"header-2\"> This is a header\r</div><div class=\"paragraph\">Let's talk about content.</div></div>"
    assert rendered_post.author == author
  end
end

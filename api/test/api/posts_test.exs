defmodule Api.Post.ServiceTest do
  use ApiWeb.ConnCase
  import Api.Factory
  alias Api.Repo

  @post_service Application.get_env(:api, :post_service)

  describe "create_post/4" do
    test "should create a post" do
      user = insert(:user)

      {:ok, post} =
        @post_service.create_post(%{
          "author_id" => user.id,
          "title" => "My Post",
          "content" => "My Content",
          "is_private" => false
        })

      assert post.author_id == user.id
      assert post.title == "My Post"
      assert post.content == "My Content"
      assert !post.is_private
      assert !is_nil(post.id)
    end

    test "should return an error for a non-existent user" do
      {:error, _} =
        @post_service.create_post(%{
          "author_id" => 1,
          "title" => "Hack 4 LuLz",
          "content" => "Power Overwhelming",
          "is_private" => false
        })
    end
  end

  describe "update_post" do
    test "should update an existing post" do
      author = insert(:user)
      post = insert(:post, author: author)

      new_post = %{
        "author_id" => author.id,
        "title" => "Updated Title",
        "content" => "Updated Content",
        "is_private" => false
      }

      {:ok, post} = @post_service.update_post(post.id, new_post)
      assert post.title == "Updated Title"
      assert post.content == "Updated Content"
    end

    test "should return an error if updating a non-existent post" do
      author = insert(:user)

      new_post = %{
        "author_id" => author.id,
        "title" => "Updated Title",
        "content" => "Updated Content",
        "is_private" => false
      }

      {:error, _} = @post_service.update_post(1000, new_post)
    end
  end

  describe "get_posts_by_author/1" do
    test "should get all posts for an author" do
      author1 = insert(:user)
      author2 = insert(:user)
      post1 = insert(:post, author: author1)
      post2 = insert(:post, author: author1)
      _post3 = insert(:post, author: author2)

      [p1, p2] = @post_service.get_posts_by_author(author1.id)
      assert p1.id == post1.id
      assert p1.author_id == author1.id
      assert p2.id == post2.id
      assert p2.author_id == author1.id
    end
  end

  describe "get_post_by_id/2" do
    test "should get a post" do
      author = insert(:user)
      control = insert(:post, author: author)

      {:ok, post} = @post_service.get_post_by_id(author.id, control.id)
      post = Repo.preload(post, :author)

      assert post.id == control.id
      assert post.title == control.title
      assert post.author.id == control.author.id
    end

    test "should return nil for a non-existent post" do
      author = insert(:user)
      {:ok, nil} = @post_service.get_post_by_id(author.id, 100)
    end
  end
end

defmodule Api.Posts.ContextTest do
  use ApiWeb.ConnCase
  import Api.Factory

  @post_context Application.get_env(:api, :post_context)

  describe "insert_post/2" do
    test "should insert a post for a user_id and params" do
      author = insert(:user)

      {:ok, post} =
        @post_context.insert_post(%{
          "author_id" => author.id,
          "title" => "Title",
          "content" => "Content"
        })

      assert post.author_id == author.id
      assert post.title == "Title"
      assert post.content == "Content"
      assert not is_nil(post.post_id)
    end

    # Note: good candidate for property test
    test "should not function match for non-integer arguments" do
      assert_raise FunctionClauseError, fn ->
        @post_context.insert_post(%{
          "author_id" => "hello",
          "title" => "Title",
          "content" => "Content"
        })
      end
    end

    test "should return an error for incomplete post params - title" do
      author = insert(:user)

      {:error, %{valid?: false}} =
        @post_context.insert_post(%{
          "author_id" => author.id,
          "content" => "Content"
        })
    end

    test "should return an error for incomplete post params - content" do
      author = insert(:user)

      {:error, %{valid?: false}} =
        @post_context.insert_post(%{
          "author_id" => author.id,
          "title" => "Title"
        })
    end
  end

  describe "get_post_with_author/1" do
    test "should get a post with a preloaded author" do
      post = insert(:post)
      np = @post_context.get_post_with_author(post.id)

      assert np == post
      assert np.author == post.author
    end
  end

  describe "get_next_post/1" do
    test "should return the next post" do
      author = insert(:user)
      post1 = insert(:post, author: author)
      post1_dt = DateTime.from_naive!(post1.inserted_at, "Etc/UTC")
      _post2 = insert(:post, author: author, inserted_at: DateTime.add(post1_dt, 3600, :second), is_private: true)
      post3 = insert(:post, author: author, inserted_at: DateTime.add(post1_dt, 7200, :second))

      next_post = @post_context.get_next_post(post1) |> Api.Repo.preload([:author])

      assert next_post == post3
    end

    test "should return no posts" do
      author = insert(:user)
      post1 = insert(:post, author: author)

      next_post = @post_context.get_next_post(post1) |> Api.Repo.preload([:author])

      assert next_post == nil
    end
  end

  describe "get_prev_post/1" do
    test "should return the previous post" do
      author = insert(:user)
      post1 = insert(:post, author: author)
      post1_dt = DateTime.from_naive!(post1.inserted_at, "Etc/UTC")
      post2 = insert(:post, author: author, inserted_at: DateTime.add(post1_dt, 3600, :second))
      post3 = insert(:post, author: author, inserted_at: DateTime.add(post1_dt, 7200, :second))
      _post4 = insert(:post, author: author, inserted_at: DateTime.add(post1_dt, 9000, :second), is_private: true)

      prev_post = @post_context.get_prev_post(post3) |> Api.Repo.preload([:author])

      assert prev_post == post2
    end

    test "should return no posts" do
      author = insert(:user)
      post1 = insert(:post, author: author)

      prev_post = @post_context.get_prev_post(post1) |> Api.Repo.preload([:author])

      assert prev_post == nil
    end
  end

  describe "get_latest_post_for_author/2" do
    test "should get latest post for author" do
      author = insert(:user)
      _ = insert(:post, author: author, inserted_at: ~N[2019-08-29 20:11:42])
      _ = insert(:post, author: author, inserted_at: ~N[2019-08-29 20:11:43])
      post3 = insert(:post, author: author, inserted_at: ~N[2019-08-29 20:11:44])

      post = @post_context.get_latest_post_for_author(author.username)
      assert post.id == post3.id
      assert post.author_id == post3.author_id
    end

    test "should return nil for no posts" do
      author = insert(:user)

      post = @post_context.get_latest_post_for_author(author.username)
      assert post == nil
    end
  end
end

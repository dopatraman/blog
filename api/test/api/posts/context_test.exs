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

  # TODO: have property test for all combinations of
  # Elixir primitive types
  describe "get_post/1" do
    test "should get a post by id" do
      post = insert(:post)

      new_post =
        @post_context.get_post(post.id)
        |> Api.Repo.preload([:author])

      assert new_post == post
    end

    test "should return an error for a non-existent post" do
      post = @post_context.get_post(1)
      assert post == nil
    end

    test "should return an error for non-integer values" do
      alias Ecto.Query.CastError

      assert_raise CastError, fn ->
        @post_context.get_post("hello")
      end
    end
  end

  describe "get_all_posts/1" do
    test "should return an empty list for a non-existent author_id" do
      {:error, _} = @post_context.get_all_posts(1)
    end
  end

  describe "get_latest_post_for_author/2" do
    test "should get latest post for author" do
      author = insert(:user)
      _ = insert(:post, author: author, inserted_at: ~N[2019-08-29 20:11:42])
      _ = insert(:post, author: author, inserted_at: ~N[2019-08-29 20:11:43])
      post3 = insert(:post, author: author, inserted_at: ~N[2019-08-29 20:11:44])

      post = @post_context.get_latest_post_for_author(author.id)
      assert post.id == post3.id
      assert post.author_id == post3.author_id
    end

    test "should return nil for no posts" do
      author = insert(:user)

      post = @post_context.get_latest_post_for_author(author.id)
      assert post == nil
    end
  end
end

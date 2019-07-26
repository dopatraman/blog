defmodule Api.Factory do
  use ExMachina.Ecto, repo: Api.Repo

  alias Api.Post.Schema, as: PostSchema
  alias Api.User.Schema, as: UserSchema

  def post_factory do
    %PostSchema{
      author: build(:user),
      title: "My Post",
      content: "My Content",
      is_private: false
    }
  end

  def user_factory do
    %UserSchema{
      username: Faker.Pokemon.name(),
      email: Faker.Internet.email(),
      password: "Password"
    }
  end
end

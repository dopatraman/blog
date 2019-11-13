defmodule Api.Factory do
  use ExMachina.Ecto, repo: Api.Repo

  alias Api.Posts.Schema, as: PostSchema
  alias Api.User.Schema, as: UserSchema
  alias Api.Auth.Session.Schema, as: SessionSchema

  def post_factory do
    %PostSchema{
      author: build(:user),
      title: "My Post",
      content: "My Content",
      is_private: false,
      is_processed: false
    }
  end

  # NOTE:
  # BCrypt makes this factory slow
  # Use a derived factory instead
  # for user_with_encrypted_pw and not
  # https://github.com/thoughtbot/ex_machina
  def user_factory do
    %UserSchema{
      username: Faker.Pokemon.name(),
      email: Faker.Internet.email(),
      password: Bcrypt.hash_pwd_salt(Faker.Lorem.word())
    }
  end

  def session_factory do
    %SessionSchema{
      key: Faker.UUID.v4(),
      user: build(:user),
      expires_at: Faker.DateTime.forward(1)
    }
  end
end

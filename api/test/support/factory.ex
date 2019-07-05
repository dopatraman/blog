defmodule Api.Factory do
  use ExMachina.Ecto, repo: Api.Repo

  alias Api.User.Schema, as: UserSchema

  def user_factory do
    %UserSchema{
      username: Faker.Pokemon.name(),
      email: Faker.Internet.email()
    }
  end
end

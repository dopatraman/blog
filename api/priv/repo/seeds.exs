# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Api.Repo.insert!(%Api.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Api.User.Schema, as: UserSchema

Api.Repo.insert!(
  UserSchema.changeset(%UserSchema{}, %{
    email: "admin@email.com",
    username: "admin",
    password: "admin"
  }))

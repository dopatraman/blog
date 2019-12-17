:ok = Application.ensure_started(:ex_machina)
:ok = Application.ensure_started(:faker)

ExUnit.start(exclude: [:skip])
Ecto.Adapters.SQL.Sandbox.mode(Api.Repo, :manual)

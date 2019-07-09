:ok = Application.ensure_started(:ex_machina)
:ok = Application.ensure_started(:faker)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Api.Repo, :manual)

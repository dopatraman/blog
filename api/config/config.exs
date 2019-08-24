# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api, Api.Repo,
  database: "api_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :api,
  ecto_repos: [Api.Repo]

# Configures the endpoint
config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4L3JSh8qLjE3kNYzjFcEa0GGd+SP1aroZirvU40/RXgWjWUslq7gf9Um7kcU6d+l",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Api.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian
config :api, Api.Auth.Guardian,
  issuer: "api",
  secret_key: "secretsecretsecret"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# DI
config :api, :post_service, Api.Posts.Service
config :api, :post_context, Api.Posts.Context
config :api, :auth_service, Api.Auth.Service
config :api, :auth_context, Api.Auth.Context

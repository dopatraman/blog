# In this file, we load production configuration and
# secrets from environment variables. You can also
# hardcode secrets, although such is generally not
# recommended and you have to remember to add this
# file to your .gitignore.
use Mix.Config

database_user =
  System.get_env("DATABASE_USER") ||
    raise """
    environment variable DATABASE_USER must be set.
    """

database_password =
  System.get_env("DATABASE_PASSWORD") ||
    raise """
    environment variable DATABASE_PASSWORD must be set.
    """

database_name =
  System.get_env("DATABASE_NAME") ||
    raise """
    environment variable DATABASE_NAME must be set.
    """

database_host =
  System.get_env("DATABASE_HOST") ||
    raise """
    environment variable DATABASE_HOST must be set.
    """

config :api, Api.Repo,
  # ssl: true,
  username: database_user,
  password: database_password,
  database: database_name,
  hostname: database_host,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :api, ApiWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base

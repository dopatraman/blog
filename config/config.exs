import Config

config :iex, default_prompt: ">>>"

config :blog,
  post_repo_url: "https://github.com/dopatraman/content",
  local_content_dir: Path.expand("./.content")

import_config "#{Mix.env()}.exs"

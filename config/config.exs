import Config

config :blog,
  post_repo_url: "https://github.com/dopatraman/blog-posts.git",
  local_content_dir: Path.expand("./.content")

import_config "#{Mix.env()}.exs"

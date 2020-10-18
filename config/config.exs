import Config

config :blog,
  port: 8000,
  post_repo_url: "https://github.com/dopatraman/blog-posts.git",
  local_content_dir: Path.expand("./.content"),
  template_dir: Path.expand("./lib/web/views")

import_config "#{Mix.env()}.exs"

import Config

config :blog,
  port: 8000,
  post_repo_url: "https://github.com/dopatraman/blog-posts.git",
  local_content_dir: Path.expand("./.content"),
  post_dir: Path.expand("./.content/posts"),
  template_dir: Path.expand("./lib/web/views"),
  style_dir: Path.expand("./.content/styles")

import_config "#{Mix.env()}.exs"

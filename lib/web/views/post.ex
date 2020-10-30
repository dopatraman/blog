defmodule Blog.Views.PostView do
  require EEx
  template_path = Path.join(Application.get_env(:blog, :template_dir), "post.eex")
  EEx.function_from_file(:def, :render, template_path, [:content, :style])
end

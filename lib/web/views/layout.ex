defmodule Blog.Views.LayoutView do
  require EEx
  template_path = Path.join(Application.get_env(:blog, :template_dir), "layout.eex")
  EEx.function_from_file(:def, :render, template_path, [:content])
end

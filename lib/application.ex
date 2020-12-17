defmodule Blog.Application do
  @moduledoc "Application file"

  use Application

  def start(_type, _args) do
    scheme = Application.get_env(:blog, :scheme)
    options = Application.get_env(:blog, :start_options)
    children = [
      Plug.Cowboy.child_spec(
        scheme: scheme,
        plug: Blog.Web.Endpoint,
        options: options
      )
    ]

    opts = [strategy: :one_for_one, name: Blog.Supervisor]
    IO.puts("Starting on port #{options[:port]}...")
    Supervisor.start_link(children, opts) |> IO.inspect()
  end
end

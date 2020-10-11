defmodule Blog.Application do
  @moduledoc "Application file"

  use Application

  def start(_type, _args) do
    port = Application.get_env(:blog, :port)

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Blog.Web.Endpoint,
        options: [port: port]
      )
    ]

    opts = [strategy: :one_for_one, name: Blog.Supervisor]
    IO.puts("Starting on port #{port}...")
    Supervisor.start_link(children, opts) |> IO.inspect()
  end
end

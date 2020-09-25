defmodule Blog.Application do
  @moduledoc "Application file"

  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Blog.Web.Endpoint,
        options: [port: 8000]
      )
    ]

    opts = [strategy: :one_for_one, name: Blog.Supervisor]
    IO.puts("Starting...")
    Supervisor.start_link(children, opts) |> IO.inspect()
  end
end

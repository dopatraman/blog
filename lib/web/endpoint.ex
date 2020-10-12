defmodule Blog.Web.Endpoint do
  @moduledoc """
  This is the module responsible for processing incoming requests
  """

  use Plug.Router
  import Plug.Conn, only: [send_resp: 3]

  alias Blog.Data.FilePath
  alias Blog.Web.GitHookController
  alias Blog.Web.PostWorkflow

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  post "/update" do
    case GitHookController.post_receive(conn) do
      :success -> send_resp(conn, 200, :success)
      :failure -> send_resp(conn, 400, :failure)
      :unauthorized -> send_resp(conn, 401, :unauthorized)
    end
  end

  get "/post/:path" do
    %{"path" => path} = conn.params
    {:ok, decoded_path} = Base.decode64(path)

    case PostWorkflow.serve_post(decoded_path) do
      {:ok, post_html} -> send_resp(conn, 200, post_html)
      {:error, _} -> send_resp(conn, 404, :not_found)
    end
  end

  get "/posts" do
    {:ok, d} = PostWorkflow.serve_dir() |> FilePath.as_map() |> Jason.encode([])

    send_resp(conn, 200, d)
  end
end

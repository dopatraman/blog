defmodule Blog.Web.Endpoint do
  @moduledoc """
  This is the module responsible for processing incoming requests
  """

  use Plug.Router
  import Plug.Conn, only: [send_resp: 3]

  alias Blog.Web.GitHookController
  alias Blog.Web.PostWorkflow
  alias Blog.Views.LayoutView
  alias Blog.Views.PostView

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded])
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  get "/favicon.ico" do
    send_resp(conn, 200, "icon")
  end

  get "/styles/:stylesheet" do
    %{"stylesheet" => stylesheet} = conn.params
    IO.inspect(stylesheet)
    style_path = Path.join(Application.get_env(:blog, :style_dir), stylesheet)

    case File.exists?(style_path) do
      true ->
        {:ok, content} = File.read(style_path)
        send_resp(conn, 200, content)

      _ ->
        send_resp(conn, 404, :not_found)
    end
  end

  post "/update" do
    case GitHookController.post_receive(conn.body_params) do
      :success -> send_resp(conn, 200, ":success")
      :failure -> send_resp(conn, 400, ":failure")
      :unauthorized -> send_resp(conn, 401, ":unauthorized")
    end
  end

  get "/post/:path" do
    %{"path" => path} = conn.params
    {:ok, decoded_path} = Base.decode64(path)

    case PostWorkflow.serve_post(decoded_path) do
      {:ok, post_html} ->
        send_resp(conn, 200, PostView.render(post_html, Path.join("/styles", "post.css")))

      {:error, _} ->
        send_resp(conn, 404, :not_found)
    end
  end

  get "/posts" do
    d = PostWorkflow.serve_dir()

    send_resp(
      conn,
      200,
      HTMLDisplayable.from(d)
      |> LayoutView.render(Path.join("/styles", "directory.css"))
    )
  end
end

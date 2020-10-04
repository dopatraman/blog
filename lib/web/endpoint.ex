defmodule Blog.Web.Endpoint do
  @moduledoc """
  This is the module responsible for processing incoming requests
  """

  use Plug.Router
  import Plug.Conn, only: [send_resp: 3]

  alias Blog.Web.GitHookController

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
end

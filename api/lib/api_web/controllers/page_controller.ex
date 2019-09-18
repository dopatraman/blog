defmodule ApiWeb.PageController do
  use ApiWeb, :controller

  def login(conn, _) do
    render(conn, "login.html")
  end

  def create_post(conn, _) do
    render(conn, "create.html")
  end
  
  def index(conn, _params) do
    render(conn, "index.html")
  end
end

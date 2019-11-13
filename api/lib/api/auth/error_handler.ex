defmodule Api.Auth.ErrorHandler do
  import Plug.Conn

  def auth_error(conn, _type) do
    resp(conn, 500, "Error")
  end
end

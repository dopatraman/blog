defmodule Blog.Web.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Blog.Web.Endpoint.init([])

  test "it returns pong" do
    conn = conn(:get, "/ping")
    conn = Blog.Web.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "pong"
  end
end

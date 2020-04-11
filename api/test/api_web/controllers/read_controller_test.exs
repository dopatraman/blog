defmodule ApiWeb.ReadControllerTest do
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.Endpoint
  import Api.Factory
  import Plug.Conn, only: [get_resp_header: 2, put_req_header: 3]
  use ApiWeb.ConnCase

  test "GET /read with post id", %{conn: conn} do
    post = insert(:post)

    resp = get(conn, Routes.read_path(Endpoint, :post, post.post_id))

    assert resp.status == 200
  end
end

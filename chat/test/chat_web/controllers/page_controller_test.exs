defmodule ChatWeb.PageControllerTest do
  use ChatWeb.ConnCase

  @tag :skip
  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    body = html_response(conn, 200)

    assert body =~ "Welcome to LambdaChat!"
    assert body =~ "<input"
  end

  @tag :skip
  test "GET /about", %{conn: conn} do
    conn = get conn, "/about"
    assert html_response(conn, 200) =~ "This was built"
  end
end

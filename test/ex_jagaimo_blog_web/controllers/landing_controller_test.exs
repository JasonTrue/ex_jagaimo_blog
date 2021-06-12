defmodule ExJagaimoBlogWeb.LandingControllerTest do
  use ExJagaimoBlogWeb.ConnCase

  test "Host set GET /", %{conn: conn} do
    insert(:blog, host: "foo.com")

    conn =
      conn
      |> Map.put(:host, "foo.com")
      |> get("/")

    assert html_response(conn, 200)
  end

  test "No host set GET /", %{conn: conn} do
    conn =
      conn
      |> get("/")

    assert redirected_to(conn) =~ Routes.blog_path(conn, :index)
  end
end

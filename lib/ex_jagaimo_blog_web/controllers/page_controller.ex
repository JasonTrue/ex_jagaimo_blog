defmodule ExJagaimoBlogWeb.PageController do
  use ExJagaimoBlogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

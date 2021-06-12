defmodule ExJagaimoBlogWeb.Helpers.BlogHelper do
  @moduledoc false

  alias ExJagaimoBlog.Blogs
  alias ExJagaimoBlog.Blogs.Blog

  import Plug.Conn

  def maybe_set_blog(conn) do
    host = conn.host

    case Blogs.get_blog_by_host(host, domain_opts()) do
      %Blog{} = blog -> conn |> assign(:blog, blog)
      nil -> conn
    end
  end

  def domain_opts() do
    ExJagaimoBlogWeb.Endpoint.config(:domain_opts, [])
  end
end
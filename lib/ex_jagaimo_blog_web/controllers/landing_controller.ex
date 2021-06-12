defmodule ExJagaimoBlogWeb.LandingController do
  use ExJagaimoBlogWeb, :controller

  alias ExJagaimoBlog.Blogs
  alias ExJagaimoBlog.Blogs.Blog
  alias ExJagaimoBlog.Repo

  def action(conn, _) do
    conn = maybe_set_blog(conn)
    args = [conn, conn.params]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(%Plug.Conn{assigns: %{blog: %Blog{} = blog}} = conn, _params) do
    posts = Blogs.get_latest_posts_for_blog(blog, 6)

    {top_post, highlights} =
      case posts do
        [top_post | highlights] -> {top_post, highlights}
        other -> {nil, []}
      end

    render(conn, "index.html", top_post: top_post, highlights: highlights)
  end

  def index(conn, _params) do
    conn
    |> put_flash(:info, gettext("This domain is not yet configured."))
    |> redirect(to: Routes.blog_path(conn, :index))
  end

  defp maybe_set_blog(conn) do
    host = conn.host

    case Blogs.get_blog_by_host(host, domain_opts()) do
      %Blog{} = blog -> conn |> assign(:blog, blog)
      nil -> conn
    end
  end

  defp domain_opts() do
    ExJagaimoBlogWeb.Endpoint.config(:domain_opts, [])
  end
end

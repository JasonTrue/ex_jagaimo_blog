defmodule ExJagaimoBlogWeb.PostController do
  use ExJagaimoBlogWeb, :controller

  alias ExJagaimoBlog.Blogs
  import ExJagaimoBlogWeb.Helpers.BlogHelper

  def action(conn, _) do
    conn = maybe_set_blog(conn)
    args = [conn, conn.params]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, params) do
    ymd = params |> convert_date_params_to_fields()
    conn = conn |> assign(:title, construct_title(conn.assigns.blog, ymd))

    paginated_posts =
      Blogs.query_posts()
      |> Blogs.maybe_filter_post_by_blog(conn.assigns[:blog])
      |> Blogs.maybe_filter_post_by_year_month_day(ymd)
      |> Blogs.maybe_filter_posts_by_tag_names(params["tags"])
      |> Blogs.paginate(page: parse_page_number(params["page"]), page_size: 10)

    render(conn, "index.html", paginated_posts)
  end
end

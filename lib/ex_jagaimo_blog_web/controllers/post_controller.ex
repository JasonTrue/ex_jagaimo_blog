defmodule ExJagaimoBlogWeb.PostController do
  use ExJagaimoBlogWeb, :controller

  alias ExJagaimoBlog.Blogs
  alias ExJagaimoBlog.Blogs.Post
  import ExJagaimoBlogWeb.Helpers.BlogHelper

  def action(conn, _) do
    conn = maybe_set_blog(conn)
    args = [conn, conn.params]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, params) do
    ymd = params |> convert_date_params_to_fields()
    conn = conn |> assign(:title, construct_title(conn.assigns.blog, ymd))

    paginated_posts = Blogs.query_posts()
    |> Blogs.maybe_filter_post_by_blog(conn.assigns[:blog])
    |> Blogs.maybe_filter_post_by_year_month_day(ymd)
    |> Blogs.paginate(page: parse_page_number(params["page"]), page_size: 10)
    render(conn, "index.html", paginated_posts)
  end

  def convert_date_params_to_fields(params) do
    params
    |> Map.take(["year", "month", "day"])
    |> Map.new(fn {k, v} -> {String.to_atom(k), parse_integer_or_nil(v)} end)
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
  end

  def construct_title(nil, params), do: construct_title("JagaimoBlog", params)
  def construct_title(blog, params) when map_size(params) == 0 do
    gettext("Posts from %{blog_name}", date: construct_date_from_params(params), blog_name: blog.name)
  end
  def construct_title(blog, params) do
    gettext("Posts from %{date}: %{blog_name}", date: construct_date_from_params(params), blog_name: blog.name)
  end

  #A little sloppy, as it only returns the parameters; should translate month into month name
  #at least. (adds to TODO-list)
  def construct_date_from_params(%{year: year, month: month, day: day}), do:
    dgettext("datetime", "%{month} %{day}, %{year}", year: year, month: to_month_name(month), day: day)
  def construct_date_from_params(%{year: year, month: month}), do:
    dgettext("datetime", "%{month} %{year}", year: year, month: to_month_name(month))
  def construct_date_from_params(%{year: year}), do:
    year

  def construct_date_from_params(%{} = ymd) do
    not_specified = gettext("Not specified")
    gettext("Year: %{year}, Month: %{month}, Day: %{day}",
      year: Map.get(ymd, :year) || not_specified,
      month: to_month_name(Map.get(ymd, :month))  || not_specified,
      day: Map.get(ymd, :day)  || not_specified
    )
  end

  defp to_month_name(month_number) do
    case Timex.month_name(month_number) do
      {:error, _} -> nil
      value -> value
    end
  end

  def new(conn, _params) do
    changeset = Blogs.change_post(%Post{})
    render(conn, "new.html", changeset: changeset, title: gettext("New Post"))
  end

  def create(conn, %{"post" => post_params}) do
    case Blogs.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, title: gettext("New Post"))
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blogs.get_post!(id)
    render(conn, "show.html", post: post, title: post.title)
  end

  def edit(conn, %{"id" => id}) do
    post = Blogs.get_post!(id)
    changeset = Blogs.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset, title: gettext("Editing %{post_title}", post_title: post.title))
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blogs.get_post!(id)

    case Blogs.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset, title: gettext("Editing %{post_title}", post_title: post.title))
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blogs.get_post!(id)
    {:ok, _post} = Blogs.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  defp parse_integer_or_nil(text) when is_binary(text) do
    case Integer.parse(text) do
      {integer, ""} -> integer
      _other -> nil
    end
  end
  defp parse_integer_or_nil(_), do: nil

  defp parse_page_number(text) do
    page_number = parse_integer_or_nil(text)
    cond do
      page_number == nil -> 1
      page_number < 1 -> 1
      true -> page_number
    end
  end
end

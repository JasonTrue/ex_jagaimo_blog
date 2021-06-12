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
    paginated_posts = Blogs.query_posts()
    |> Blogs.maybe_filter_post_by_blog(conn.assigns[:blog])
    |> Blogs.maybe_filter_post_by_year(params["year"] |> parse_integer_or_nil())
    |> Blogs.maybe_filter_post_by_month(params["month"] |> parse_integer_or_nil())
    |> Blogs.maybe_filter_post_by_month(params["day"] |> parse_integer_or_nil())
    |> Blogs.paginate(page: parse_page_number(params["page"]), page_size: 10)
    render(conn, "index.html", paginated_posts)
  end

  def new(conn, _params) do
    changeset = Blogs.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Blogs.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blogs.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Blogs.get_post!(id)
    changeset = Blogs.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blogs.get_post!(id)

    case Blogs.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
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

defmodule ExJagaimoBlogWeb.BlogController do
  use ExJagaimoBlogWeb, :controller

  alias ExJagaimoBlog.Blogs
  alias ExJagaimoBlog.Blogs.Blog
  alias Plug.Conn

  def action(conn, _params) do
    conn =
      conn
      |> assign(:host_suffix, host_suffix())

    args = [conn, conn.params]
    apply(__MODULE__, action_name(conn), args)
  end

  @spec index(%Conn{}, map()) :: no_return()
  def index(conn, _params) do
    blogs = Blogs.list_blogs()
    render(conn, "index.html", blogs: blogs)
  end

  @spec new(%Conn{}, map()) :: no_return()
  def new(conn, _params) do
    changeset = Blogs.change_blog(%Blog{})
    render(conn, "new.html", changeset: changeset, title: gettext("New blog"))
  end

  @spec create(%Conn{}, map()) :: no_return()
  def create(conn, %{"blog" => blog_params}) do
    case Blogs.create_blog(blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, "Blog created successfully.")
        |> redirect(to: Routes.blog_path(conn, :show, blog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, title: gettext("New blog"))
    end
  end

  @spec show(%Conn{}, map()) :: no_return()
  def show(conn, %{"id" => id}) do
    blog = Blogs.get_blog!(id)

    render(conn, "show.html",
      blog: blog,
      title: gettext("Show blog configuration: %{blog_name}", blog_name: blog.name)
    )
  end

  @spec edit(%Conn{}, map()) :: no_return()
  def edit(conn, %{"id" => id}) do
    blog = Blogs.get_blog!(id)
    changeset = Blogs.change_blog(blog)
    render(conn, "edit.html", blog: blog, changeset: changeset)
  end

  @spec update(%Conn{}, map()) :: no_return()
  def update(conn, %{"id" => id, "blog" => blog_params}) do
    blog = Blogs.get_blog!(id)

    case Blogs.update_blog(blog, blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, "Blog updated successfully.")
        |> redirect(to: Routes.blog_path(conn, :show, blog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", blog: blog, changeset: changeset)
    end
  end

  @spec delete(%Conn{}, map()) :: no_return()
  def delete(conn, %{"id" => id}) do
    blog = Blogs.get_blog!(id)
    {:ok, _blog} = Blogs.delete_blog(blog)

    conn
    |> put_flash(:info, "Blog deleted successfully.")
    |> redirect(to: Routes.blog_path(conn, :index))
  end

  def host_suffix do
    opts =
      ExJagaimoBlogWeb.Endpoint.config(:domain_opts, [])
      |> Enum.into(%{})

    opts |> Map.get(:host_suffix, '')
  end
end

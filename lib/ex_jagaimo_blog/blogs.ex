defmodule ExJagaimoBlog.Blogs do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias ExJagaimoBlog.Repo

  alias ExJagaimoBlog.Blogs.Post
  alias ExJagaimoBlog.Blogs.Blog

  @domain_opts %{
    optional_suffixes: nil
  }

  def list_blogs() do
    Repo.all(Blog)
  end

  def get_blog_by_host(host, domain_opts \\ []) do
    query_blogs_by_host(host, domain_opts)
    |> Repo.one()
  end

  def query_blogs_by_host(host, domain_opts) do
    opts = Enum.into(domain_opts, @domain_opts)

    # Search for either the actual host name or use the current hostname minus
    # any optional suffixes.
    candidate_hosts =
      [
        host
        | Enum.map(opts.optional_suffixes || [], fn suffix ->
            String.replace_trailing(host, suffix, "")
          end)
      ]
      |> Enum.uniq()

    from b in Blog, where: b.host in ^candidate_hosts
  end

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def query_posts() do
    from(post in Post)
  end

  def filter_posts_by_blog(post_query, %Blog{} = blog) do
    from post in post_query, where: post.blog_id == ^blog.id
  end

  def reverse_chronological(query) do
    from post in query, order_by: [desc: :publish_at]
  end

  def get_latest_posts_for_blog(blog, count \\ 20) do
    query_posts()
    |> reverse_chronological()
    |> filter_posts_by_blog(blog)
    |> limit(^count)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def maybe_filter_post_by_blog(post_query, %Blog{id: blog_id}) do
    from post in post_query, where: post.blog_id == ^blog_id
  end

  def maybe_filter_post_by_blog(post_query, nil) do
    post_query
  end

  def maybe_filter_post_by_year(post_query, nil), do: post_query
  def maybe_filter_post_by_year(post_query, year) do
    from post in post_query, where: fragment("date_part('year', ?)", post.publish_at) == ^year
  end

  def maybe_filter_post_by_month(post_query, nil), do: post_query
  def maybe_filter_post_by_month(post_query, month) do
    from post in post_query, where: fragment("date_part('month', ?)", post.publish_at) == ^month
  end

  def maybe_filter_post_by_day(post_query, nil), do: post_query
  def maybe_filter_post_by_day(post_query, day) do
    from post in post_query, where: fragment("date_part('day', ?)", post.publish_at) == ^day
  end

  @default_pagination %{
    page_count: 0,
    page_size: 10,
    page: 1,
    entries: 0,
    offset: 0,
    count: 0
  }

  def paginate(post_query, options \\ []) do
    pagination = %{page_size: page_size, page: current_page} = Enum.into(options, @default_pagination)
    count = Repo.aggregate(post_query, :count, :id)
    offset = (current_page - 1) * page_size
    page_count = trunc(count / page_size) + 1

    posts = (from post in post_query)
    |> offset(^offset)
    |> limit(^page_size)
    |> Repo.all()

    %{pagination | entries: posts, offset: offset, page_count: page_count, count: count}
  end


  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias ExJagaimoBlog.Blogs.Blog

  @doc """
  Gets a single blog.

  Raises if the Blog does not exist.

  ## Examples

      iex> get_blog!(123)
      %Blog{}

  """
  def get_blog!(id), do: Repo.get!(Blog, id)

  @doc """
  Creates a blog.

  ## Examples

      iex> create_blog(%{field: value})
      {:ok, %Blog{}}

      iex> create_blog(%{field: bad_value})
      {:error, ...}

  """
  def create_blog(_attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a blog.

  ## Examples

      iex> update_blog(blog, %{field: new_value})
      {:ok, %Blog{}}

      iex> update_blog(blog, %{field: bad_value})
      {:error, ...}

  """
  def update_blog(%Blog{} = _blog, _attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Blog.

  ## Examples

      iex> delete_blog(blog)
      {:ok, %Blog{}}

      iex> delete_blog(blog)
      {:error, ...}

  """
  def delete_blog(%Blog{} = _blog) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking blog changes.

  ## Examples

      iex> change_blog(blog)
      %Todo{...}

  """
  def change_blog(%Blog{} = _blog, _attrs \\ %{}) do
    raise "TODO"
  end
end

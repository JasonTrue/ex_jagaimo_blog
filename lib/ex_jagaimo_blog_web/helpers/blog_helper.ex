defmodule ExJagaimoBlogWeb.Helpers.BlogHelper do
  @moduledoc false

  alias ExJagaimoBlog.Blogs
  alias ExJagaimoBlog.Blogs.Blog
  import ExJagaimoBlogWeb.Gettext

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

  def convert_date_params_to_fields(params) do
    params
    |> Map.take(["year", "month", "day"])
    |> Map.new(fn {k, v} -> {String.to_atom(k), parse_integer_or_nil(v)} end)
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
  end

  def has_date_filter?(params) do
    params
    |> Map.take(["year", "month", "day"])
    |> Enum.any?()
  end

  def posts_list_title(blog, params \\ []) do
    opts =
      params
      |> Enum.into(%{date: nil, tags: nil})

    build_posts_list_title(blog, opts)
  end

  defp build_posts_list_title(nil, %{date: nil, tags: nil}), do: gettext("Posts")

  defp build_posts_list_title(nil, %{date: %{year: nil, month: nil, day: nil}, tags: nil}),
    do: gettext("Posts")

  defp build_posts_list_title(nil, %{date: %{} = date, tags: nil}) when map_size(date) == 0,
    do: gettext("Posts")

  defp build_posts_list_title(nil, %{date: %{} = date, tags: nil}) do
    gettext("%{date} posts", date: construct_date_from_params(date))
  end

  defp build_posts_list_title(nil, %{date: %{} = date, tags: [_ | _] = tags}) do
    joined_tags = tags |> Stream.map(fn tag -> "\"#{tag}\"" end) |> Enum.join(", ")

    gettext("%{date} posts tagged %{tags}",
      date: construct_date_from_params(date),
      tags: joined_tags
    )
  end

  defp build_posts_list_title(%Blog{name: blog_name}, %{date: nil, tags: nil}),
    do: gettext("Posts: %{blog_name}", blog_name: blog_name)

  defp build_posts_list_title(%Blog{} = blog, %{
         date: %{year: nil, month: nil, day: nil},
         tags: nil
       }),
       do: build_posts_list_title(blog, %{date: nil, tags: nil})

  defp build_posts_list_title(%Blog{name: blog_name}, %{date: %{} = date, tags: nil})
       when map_size(date) == 0,
       do: gettext("Posts: %{blog_name}", blog_name: blog_name)

  defp build_posts_list_title(%Blog{name: blog_name}, %{date: %{} = date, tags: nil}) do
    gettext("%{date} posts: %{blog_name}",
      date: construct_date_from_params(date),
      blog_name: blog_name
    )
  end

  defp build_posts_list_title(%Blog{name: blog_name}, %{date: date, tags: [_ | _] = tags})
       when map_size(date) == 0 do
    gettext("Posts tagged %{tags}: %{blog_name}", tags: join_tags(tags), blog_name: blog_name)
  end

  defp build_posts_list_title(%Blog{} = blog, %{
         date: %{year: nil, month: nil, day: nil},
         tags: [_ | _] = tags
       }),
       do: build_posts_list_title(blog, %{date: %{}, tags: tags})

  defp build_posts_list_title(%Blog{name: blog_name}, %{date: %{} = date, tags: [_ | _] = tags}) do
    gettext("%{date} posts tagged %{tags}: %{blog_name}",
      date: construct_date_from_params(date),
      blog_name: blog_name,
      tags: join_tags(tags)
    )
  end

  defp join_tags([_ | _] = tags) do
    tags |> Stream.map(fn tag -> "\"#{tag}\"" end) |> Enum.join(", ")
  end

  # A little sloppy, as it only returns the parameters; should translate month into month name
  # at least. (adds to TODO-list)
  def construct_date_from_params(%{year: year, month: month, day: day}),
    do:
      dgettext("datetime", "%{month} %{day}, %{year}",
        year: year,
        month: to_month_name(month),
        day: day
      )

  def construct_date_from_params(%{year: year, month: month}),
    do: dgettext("datetime", "%{month} %{year}", year: year, month: to_month_name(month))

  def construct_date_from_params(%{year: year}), do: year

  def construct_date_from_params(%{} = ymd) do
    not_specified = gettext("Not specified")

    gettext("Year: %{year}, Month: %{month}, Day: %{day}",
      year: Map.get(ymd, :year) || not_specified,
      month: to_month_name(Map.get(ymd, :month)) || not_specified,
      day: Map.get(ymd, :day) || not_specified
    )
  end

  defp to_month_name(month_number) do
    case Timex.month_name(month_number) do
      {:error, _} -> nil
      value -> value
    end
  end

  defp parse_integer_or_nil(text) when is_binary(text) do
    case Integer.parse(text) do
      {integer, ""} -> integer
      _other -> nil
    end
  end

  defp parse_integer_or_nil(_), do: nil

  def parse_page_number(text) do
    page_number = parse_integer_or_nil(text)

    cond do
      page_number == nil -> 1
      page_number < 1 -> 1
      true -> page_number
    end
  end
end

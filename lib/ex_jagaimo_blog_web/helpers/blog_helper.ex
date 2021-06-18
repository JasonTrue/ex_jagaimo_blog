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

  def construct_title(nil, params), do: construct_title("JagaimoBlog", params)

  def construct_title(blog, params) when map_size(params) == 0 do
    gettext("Posts from %{blog_name}",
      date: construct_date_from_params(params),
      blog_name: blog.name
    )
  end

  def construct_title(blog, params) do
    gettext("Posts from %{date}: %{blog_name}",
      date: construct_date_from_params(params),
      blog_name: blog.name
    )
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

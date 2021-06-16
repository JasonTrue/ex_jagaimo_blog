defmodule ExJagaimoBlog.Tags do
  @moduledoc """
  The Tags context.
  """

  import Ecto.Query, warn: false
  alias ExJagaimoBlog.Repo
  alias ExJagaimoBlog.Blogs.{Blog, Post}

  def list_ranked_tags_by_blog(%Blog{id: blog_id}) do
    from post in Post,
      where: post.blog_id == ^blog_id,
      inner_join: tag in assoc(post, :tags),
      group_by: [tag.id, tag.name],
      order_by: [desc: count(post.id)],
      select: {count(post.id), tag.id, tag.name}
  end

  def normalize_tag_sizes(query) do
    query
    |> limit(100)
    |> Repo.all
    |> Enum.map(fn {count, _tag_id, tag_name} -> {:math.log10(count), tag_name} end)
    |> scale_tags()
  end

  defp scale_tags([]), do: []
  defp scale_tags([_ | _] = items) do
    {min, max} = items
    |> Enum.map(fn {count, _} -> count end)
    |> Enum.min_max()

    {target_min, target_max} = {0, 10}
    Enum.map(items, fn {count, name} ->
      {name, target_min + ((count - target_min) / (max - min) * (target_max - target_min))}
    end)
  end

  def sort_tag_sizes_by_name([]) do
    []
  end
  def sort_tag_sizes_by_name([{_name, _count} | _] = items) do
    items |> Enum.sort_by(fn {name, _count} -> String.downcase(name) end)
  end
end

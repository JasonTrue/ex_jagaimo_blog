defmodule ExJagaimoBlog.Tags do
  @moduledoc """
  The Tags context.
  """

  import Ecto.Query, warn: false
  alias ExJagaimoBlog.Blogs.{Blog, Post}

  def list_ranked_tags_by_blog(%Blog{id: blog_id}) do
    from post in Post,
      where: post.blog_id == ^blog_id,
      inner_join: tag in assoc(post, :tags),
      group_by: [tag.id, tag.name],
      order_by: [desc: count(post.id)],
      select: {count(post.id), tag.id, tag.name}
  end
end

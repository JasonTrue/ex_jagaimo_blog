defmodule ExJagaimoBlog.Tags.PostTagging do
  @moduledoc false
  use Ecto.Schema

  alias ExJagaimoBlog.Blogs.Post
  alias ExJagaimoBlog.Tags.Tag

  @timestamps_opts [type: :utc_datetime]

  schema "post_taggings" do
    belongs_to :tag, Tag
    belongs_to :post, Post
  end
end

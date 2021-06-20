defmodule ExJagaimoBlog.Blogs.Post do
  @moduledoc """
    Represents a blog post.
  """
  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  import Ecto.Changeset
  alias ExJagaimoBlog.Accounts.User
  alias ExJagaimoBlog.Blogs.Blog

  schema "posts" do
    belongs_to :user, User
    belongs_to :blog, Blog
    field :title, :string
    field :story, :string
    field :publish_at, :utc_datetime
    field :approved, :boolean
    field :slug, :string
    field :alternate_id, :integer
    many_to_many :tags, ExJagaimoBlog.Tags.Tag, join_through: ExJagaimoBlog.Tags.PostTagging
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [])
    |> validate_required([])
  end
end

defimpl Phoenix.Param, for: ExJagaimoBlog.Blogs.Post do
  alias ExJagaimoBlog.Blogs.Post
  def to_param(%Post{slug: nil, alternate_id: nil, id: id}), do: id
  def to_param(%Post{slug: nil, alternate_id: id}), do: id
  def to_param(%Post{slug: slug}), do: slug
end

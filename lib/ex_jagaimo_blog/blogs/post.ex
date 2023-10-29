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

  @doc """
      Converts a %Post{} to an ElasticSearch document. May raise
      Floki.ParseError if the `post.story` html is broken.

      Expects tags, blog and user attributes to be preloaded.
  """
  def to_elastic_doc!(%__MODULE__{} = post) do
    case to_elastic_doc(post) do
      {:ok, elastic_doc} -> elastic_doc
      {:error, context} -> raise ExJagaimoBlog.PostError, message: context
    end
  end

  @doc """
      Converts a %Post{} to an ElasticSearch document.

      Expects tags, blog and user attributes to be preloaded.
  """
  def to_elastic_doc(%__MODULE__{} = post) do
    case Floki.parse_fragment(post.story) do
      {:ok, story_parsed} ->
        {:ok,
         %{
           id: post.id,
           title: post.title,
           slug: post.slug,
           blog: %{
             id: post.blog.id,
             name: post.blog.name
           },
           author: post.user.name,
           publish_at: post.publish_at,
           story_text: Floki.text(story_parsed),
           tags: post.tags |> Enum.map(& &1.name)
         }}

      error ->
        error
    end
  end
end

defimpl Phoenix.Param, for: ExJagaimoBlog.Blogs.Post do
  alias ExJagaimoBlog.Blogs.Post
  def to_param(%Post{slug: nil, alternate_id: nil, id: id}), do: id
  def to_param(%Post{slug: nil, alternate_id: id}), do: id
  def to_param(%Post{slug: slug}), do: slug
end

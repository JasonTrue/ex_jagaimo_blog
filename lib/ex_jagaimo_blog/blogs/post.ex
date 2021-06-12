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
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [])
    |> validate_required([])
  end
end

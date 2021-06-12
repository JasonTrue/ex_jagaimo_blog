defmodule ExJagaimoBlog.Blogs.Blog do
  @moduledoc """
    Supports management and configuration of blogs.
  """

  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  import Ecto.Changeset
  alias ExJagaimoBlog.Blogs.Post

  schema "blogs" do
    field :name, :string
    field :subheading, :string
    field :description, :string
    field :host, :string
    field :image_cdn_url_pattern, :string
    field :google_analytics, :string
    field :supports_ssl, :boolean
    has_many :posts, Post
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([:name])
  end
end

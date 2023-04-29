defmodule ExJagaimoBlog.Search.Cluster do
  @moduledoc false
  use Snap.Cluster, otp_app: :ex_jagaimo_blog
end

defmodule ExJagaimoBlog.Search do
  @moduledoc """
      Search features.

      When an elastic instance is available, ensure that the account has permissions to create an index and index mapping.

    `ExJagaimoBlog.Search.create_post_index()` will do that.

    run `ExJagaimoBlog.Search.reindex_posts()` to build the initial index.

  """

  @post_mappings %{
    mappings: %{
      properties: %{
        id: %{
          type: :integer
        },
        title: %{
          type: :text
        },
        slug: %{
          type: :keyword
        },
        blog: %{
          properties: %{
            id: %{
              type: :integer
            },
            name: %{
              type: :text
            }
          }
        },
        author: %{
          type: :keyword
        },
        publish_at: %{
          type: :date
        },
        story_text: %{
          type: :text
        },
        tags: %{
          type: :keyword
        }
      }
    }
  }

  @doc """
    Creates a backing index for blog post search.
  """
  def create_post_index() do
    Snap.Indexes.create(
      ExJagaimoBlog.Search.Cluster,
      "posts",
      @post_mappings
    )
  end

  @doc """
    Reindexes all blog posts, 1000 items at a time.

    returns {:ok, [:ok, ...]} if successfully submitted to ElasticSearch batch indexing.

    Only tested with relatively small amounts of data so far.
  """
  def reindex_posts() do
    ExJagaimoBlog.Repo.transaction(fn ->
      ExJagaimoBlog.Blogs.query_posts()
      |> ExJagaimoBlog.Repo.stream()
      |> Stream.chunk_every(1_000)
      |> Stream.map(fn chunk ->
        chunk
        |> ExJagaimoBlog.Repo.preload([:blog, :tags, :user])
        |> Enum.map(&snap_bulk_index(&1))
        |> Snap.Bulk.perform(ExJagaimoBlog.Search.Cluster, "posts", [])
      end)
      |> Enum.to_list()
    end)
  end

  defp snap_bulk_index(post) do
    %Snap.Bulk.Action.Index{
      _id: post.id,
      doc: ExJagaimoBlog.Blogs.Post.to_elastic_doc(post)
    }
  end
end

defmodule ExJagaimoBlog.Repo.Migrations.CreatePostTaggings do
  use Ecto.Migration

  def change do
    create table(:post_taggings) do
      add :post_id, references(:posts)
      add :tag_id, references(:tags)
    end

    execute(
      "insert into post_taggings (post_id, tag_id) select taggable_id as post_id, tag_id from taggings where taggable_type='Post';"
    )
  end
end

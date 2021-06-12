defmodule ExJagaimoBlog.Repo.Migrations.LegacySchema do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:blogs) do
      add :name, :text
      add :subheading, :string, size: 512
      add :description, :text
      add :host, :text
      add :image_cdn_url_pattern, :text
      add :google_analytics, :text
      add :supports_ssl, :boolean
      timestamps(inserted_at: :created_at)
    end

    # Ecto doesn't really "get" varchar() columns with no specified size
    # To be more Ecto-idiomatic, we alter the few jagaimoblog legacy varchar()
    # fields to be the text type.
    alter table(:blogs) do
      modify :name, :text
      modify :description, :text
      modify :host, :text
      modify :image_cdn_url_pattern, :text
    end

    rename table(:blogs), :created_at, to: :inserted_at

    #    t.index ["email"], name: "index_users_on_email", unique: true
    #    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

    create_if_not_exists table(:users) do
      add :name, :text
      add :email, :string, default: "", null: false
      add :profile, :text
      add :encrypted_password, :text, default: "", null: false
      add :reset_password_token, :text
      add :reset_password_sent_at, :utc_datetime
      add :remember_created_at, :utc_datetime
      add :sign_in_count, :integer, default: 0, null: false
      add :current_sign_in_at, :utc_datetime
      add :last_sign_in_at, :utc_datetime
      add :current_sign_in_ip, :text
      add :last_sign_in_ip, :text

      timestamps(inserted_at: :created_at)
    end

    # JagaimoBlog had a unique index on email. It was slightly wrong.
    # converting to citet will make it not case-sensistive
    execute "DROP INDEX IF EXISTS index_users_on_email"
    execute "DROP INDEX IF EXISTS index_users_on_reset_password_token"

    execute "CREATE EXTENSION IF NOT EXISTS citext"

    alter table(:users) do
      modify :name, :text
      modify :email, :citext
      modify :encrypted_password, :text
      modify :reset_password_token, :text
      modify :current_sign_in_ip, :text
      modify :last_sign_in_ip, :text
    end

    rename table(:users), :created_at, to: :inserted_at

    create unique_index(:users, :email)
    create unique_index(:users, :reset_password_token)

    create_if_not_exists table(:authorships) do
      add :user_id, references(:users)
      add :blog_id, references(:blogs)
      add :admin, :boolean
      timestamps(inserted_at: :created_at)
    end

    rename table(:authorships), :created_at, to: :inserted_at

    execute "DROP INDEX IF EXISTS index_authorships_on_blog_id"
    execute "DROP INDEX IF EXISTS index_authorships_on_user_id"

    create index(:authorships, :blog_id)
    create index(:authorships, :user_id)

    create_if_not_exists table(:social_networks) do
      add :network, :text
      add :username, :text
      add :name, :text
      add :sociable_type, :text
      add :sociable_id, :integer
      timestamps(inserted_at: :created_at)
    end

    alter table(:social_networks) do
      modify :network, :text
      modify :username, :text
      modify :name, :text
      modify :sociable_type, :text
    end

    rename table(:social_networks), :created_at, to: :inserted_at

    execute "DROP INDEX IF EXISTS index_social_networks_on_sociable_id"
    execute "DROP INDEX IF EXISTS index_social_networks_on_sociable_id_and_sociable_type"

    create index(:social_networks, :sociable_id)
    create index(:social_networks, [:sociable_id, :sociable_type])

    create_if_not_exists table(:posts) do
      add :user_id, references(:users)
      add :blog_id, references(:blogs)
      add :title, :text
      add :story, :text
      add :publish_at, :utc_datetime
      add :approved, :boolean
      add :slug, :text
      add :alternate_id, :integer
      timestamps(inserted_at: :created_at)
    end

    alter table(:posts) do
      modify :title, :text
      modify :story, :text
    end

    rename table(:posts), :created_at, to: :inserted_at

    execute "DROP INDEX IF EXISTS index_posts_on_alternate_id"
    execute "DROP INDEX IF EXISTS index_posts_on_blog_id"
    execute "DROP INDEX IF EXISTS index_posts_on_slug_and_blog_id"
    execute "DROP INDEX IF EXISTS index_posts_on_user_id"

    create index(:posts, :alternate_id)
    create index(:posts, :blog_id)
    create unique_index(:posts, [:slug, :blog_id])
    create index(:posts, :user_id)

    create_if_not_exists table(:comments) do
      add :title, :string, size: 256
      add :comment, :text
      add :commentable_type, :text
      add :commentable_id, :integer
      add :user_id, references(:users)
      add :role, :text
      add :ip_address, :text
      add :visitor_name, :text
      add :title_url, :text
      add :trackback_name, :text
      timestamps(inserted_at: :created_at)
    end

    alter table(:comments) do
      modify :commentable_type, :text
      modify :ip_address, :text
      modify :visitor_name, :text
      modify :title, :text
      modify :title_url, :text
      modify :trackback_name, :text
    end

    rename table(:comments), :created_at, to: :inserted_at

    execute "DROP INDEX IF EXISTS index_comments_on_commentable_id"
    execute "DROP INDEX IF EXISTS index_comments_on_commentable_type"
    execute "DROP INDEX IF EXISTS index_comments_on_user_id"

    create index(:comments, :commentable_id)
    create index(:comments, :commentable_type)
    create index(:comments, :user_id)

    create_if_not_exists table(:tags) do
      add :name, :text
      add :taggings_count, :integer
    end

    execute "DROP INDEX IF EXISTS index_tags_on_name"
    create index(:tags, :name)

    create_if_not_exists table(:taggings) do
      add :tag_id, :integer
      add :taggable_type, :text
      add :taggable_id, :integer
      add :tagger_type, :text
      add :tagger_id, :integer
      add :context, :string, size: 128
      timestamps(inserted_at: :created_at)
    end

    alter table(:taggings) do
      modify :taggable_type, :text
      modify :tagger_type, :text
    end

    rename table(:taggings), :created_at, to: :inserted_at

    execute "DROP INDEX IF EXISTS index_taggings_on_context"
    execute "DROP INDEX IF EXISTS index_taggings_on_tag_id"
    execute "DROP INDEX IF EXISTS index_taggings_on_taggable_id"
    execute "DROP INDEX IF EXISTS index_taggings_on_taggable_id_and_taggable_type_and_context"
    execute "DROP INDEX IF EXISTS index_taggings_on_taggable_type"
    execute "DROP INDEX IF EXISTS index_taggings_on_tagger_id"
    execute "DROP INDEX IF EXISTS index_taggings_on_tagger_id_and_tagger_type"
    execute "DROP INDEX IF EXISTS taggings_idx"
    execute "DROP INDEX IF EXISTS taggings_idy"

    create index(:taggings, :context)
    create index(:taggings, :tag_id)
    create index(:taggings, :taggable_id)
    create index(:taggings, [:taggable_id, :taggable_type, :context])
    create index(:taggings, :taggable_type)
    create index(:taggings, :tagger_id)
    create index(:taggings, [:tagger_id, :tagger_type])

    create unique_index(:taggings, [
             :tag_id,
             :taggable_id,
             :taggable_type,
             :context,
             :tagger_id,
             :tagger_type
           ])

    create index(:taggings, [:taggable_id, :tagger_type, :tagger_id, :context])

    create_if_not_exists table(:friendly_id_slugs) do
      add :slug, :text
      add :sluggable_id, :integer
      add :sluggable_type, :varchar, size: 50
      add :scope, :text
      timestamps(inserted_at: :created_at)
    end

    alter table(:friendly_id_slugs) do
      modify :scope, :text
    end

    rename table(:friendly_id_slugs), :created_at, to: :inserted_at

    execute "DROP INDEX IF EXISTS index_friendly_id_slugs_on_slug_and_sluggable_type"
    execute "DROP INDEX IF EXISTS index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope"
    execute "DROP INDEX IF EXISTS index_friendly_id_slugs_on_sluggable_id"
    execute "DROP INDEX IF EXISTS index_friendly_id_slugs_on_sluggable_type"

    create index(:friendly_id_slugs, [:slug, :sluggable_type])
    create index(:friendly_id_slugs, [:slug, :sluggable_type, :scope])
    create index(:friendly_id_slugs, :sluggable_id)
    create index(:friendly_id_slugs, :sluggable_type)
  end
end

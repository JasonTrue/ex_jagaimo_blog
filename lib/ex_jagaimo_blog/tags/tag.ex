defmodule ExJagaimoBlog.Tags.Tag do
  @moduledoc false
  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  schema "tags" do
    field :name, :string
    field :taggings_count, :integer
  end
end

defmodule ExJagaimoBlog.Accounts.User do
  @moduledoc """
    Represents a User model
  """
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "users" do
    field :name, :string
    field :profile, :string
    field :email, :string
    field :encrypted_password, :string
    field :reset_password_token, :string
    field :reset_password_sent_at, :utc_datetime
    field :remember_created_at, :utc_datetime
    field :sign_in_count, :integer
    field :current_sign_in_at, :utc_datetime
    field :last_sign_in_at, :utc_datetime
    field :current_sign_in_ip, :string
    field :last_sign_in_ip, :string
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([:name, :email])
  end
end

defmodule ExJagaimoBlog.Repo do
  use Ecto.Repo,
    otp_app: :ex_jagaimo_blog,
    adapter: Ecto.Adapters.Postgres
end

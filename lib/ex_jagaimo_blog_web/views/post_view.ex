defmodule ExJagaimoBlogWeb.PostView do
  use ExJagaimoBlogWeb, :view

  alias ExJagaimoBlog.Blogs

  def permalink_path(_conn, %Blogs.Post{slug: slug, publish_at: publish_at}) do
    "/archive/#{publish_at.year()}/#{publish_at.month()}/#{publish_at.day()}/#{slug}"
  end
end

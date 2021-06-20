defmodule ExJagaimoBlogWeb.CommonViewHelpers do
  @moduledoc """
    Common view functions
  """
  alias ExJagaimoBlog.Blogs

  def permalink_path(_conn, %Blogs.Post{slug: slug, publish_at: publish_at}) do
    "/archive/#{publish_at.year()}/#{publish_at.month()}/#{publish_at.day()}/#{slug}"
  end
end

defmodule ExJagaimo.Blogs.PostTest do
  use ExUnit.Case

  alias ExJagaimoBlog.Blogs.{Post, Blog}
  alias ExJagaimoBlog.Tags.Tag
  alias ExJagaimoBlog.Accounts.User

  @moduletag :capture_log

  @good_post %Post{
    id: 1,
    title: "Title",
    blog: %Blog{id: 1, name: "Example blog"},
    user: %User{name: "foo", email: "jason@example.com"},
    tags: [%Tag{name: "Tag1"}, %Tag{name: "Tag2"}]
  }
  test "Can convert post to elastic document " do
    assert {:ok,
            %{
              id: 1,
              blog: %{id: 1, name: "Example blog"},
              title: "Title",
              tags: ["Tag1", "Tag2"]
            }} = Post.to_elastic_doc(@good_post)
  end
end

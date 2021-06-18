defmodule ExJagaimoBlogWeb.Helpers.BlogHelperTest do
  use ExUnit.Case

  alias ExJagaimoBlogWeb.Helpers.BlogHelper
  alias ExJagaimoBlog.Blogs.Blog

  @moduletag :capture_log

  doctest BlogHelper

  test "module exists" do
    assert is_list(BlogHelper.module_info())
  end

  describe "title construction" do
    test "Posts index with no blog and no date filters" do
      assert "Posts" == BlogHelper.posts_list_title(nil)
    end

    test "Posts index with no blog, nil params on date filters, and two filtered tags" do
      assert "Posts" ==
               BlogHelper.posts_list_title(nil, date: %{year: nil, month: nil, day: nil})
    end

    test "Posts index with no blog, August 2020 date filters, and two filtered tags" do
      assert "August 23, 2020 posts" ==
               BlogHelper.posts_list_title(nil, date: %{year: 2020, month: 8, day: 23})
    end

    test "Posts index with no blog and August 23, 2020 date filters" do
      assert "August 2020 posts tagged \"Foo\", \"Bar\"" ==
               BlogHelper.posts_list_title(
                 nil,
                 date: %{year: 2020, month: 8},
                 tags: ["Foo", "Bar"]
               )
    end

    @blog %Blog{id: 1, name: "My Blog"}
    test "Posts index with Named blog and no date filters" do
      assert "Posts: My Blog" == BlogHelper.posts_list_title(@blog)
    end

    test "Posts index with Named blog, nil params on date filters, and two filtered tags" do
      assert "Posts: My Blog" ==
               BlogHelper.posts_list_title(@blog, date: %{year: nil, month: nil, day: nil})
    end

    test "Posts index with Named blog, August 2020 date filters, and two filtered tags" do
      assert "August 23, 2020 posts: My Blog" ==
               BlogHelper.posts_list_title(@blog, date: %{year: 2020, month: 8, day: 23})
    end

    test "Posts index with Named blog and August 23, 2020 date filters" do
      assert "August 2020 posts tagged \"Foo\", \"Bar\": My Blog" ==
               BlogHelper.posts_list_title(
                 @blog,
                 date: %{year: 2020, month: 8},
                 tags: ["Foo", "Bar"]
               )
    end
  end
end

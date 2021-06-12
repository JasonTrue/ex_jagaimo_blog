defmodule ExJagaimoBlog.BlogsTest do
  use ExJagaimoBlog.DataCase

  #  alias ExJagaimoBlog.Blogs
  #
  #  describe "blogs" do
  #    alias ExJagaimoBlog.Blogs.Blog
  #
  #    @valid_attrs %{}
  #    @update_attrs %{}
  #    @invalid_attrs %{}
  #
  #    def blog_fixture(attrs \\ %{}) do
  #      {:ok, blog} =
  #        attrs
  #        |> Enum.into(@valid_attrs)
  #        |> Blogs.create_blog()
  #
  #      blog
  #    end
  #
  #    test "list_blogs/0 returns all blogs" do
  #      blog = blog_fixture()
  #      assert Blogs.list_blogs() == [blog]
  #    end
  #
  #    test "get_blog!/1 returns the blog with given id" do
  #      blog = blog_fixture()
  #      assert Blogs.get_blog!(blog.id) == blog
  #    end
  #
  #    test "create_blog/1 with valid data creates a blog" do
  #      assert {:ok, %Blog{} = blog} = Blogs.create_blog(@valid_attrs)
  #    end
  #
  #    test "create_blog/1 with invalid data returns error changeset" do
  #      assert {:error, %Ecto.Changeset{}} = Blogs.create_blog(@invalid_attrs)
  #    end
  #
  #    test "update_blog/2 with valid data updates the blog" do
  #      blog = blog_fixture()
  #      assert {:ok, %Blog{} = blog} = Blogs.update_blog(blog, @update_attrs)
  #    end
  #
  #    test "update_blog/2 with invalid data returns error changeset" do
  #      blog = blog_fixture()
  #      assert {:error, %Ecto.Changeset{}} = Blogs.update_blog(blog, @invalid_attrs)
  #      assert blog == Blogs.get_blog!(blog.id)
  #    end
  #
  #    test "delete_blog/1 deletes the blog" do
  #      blog = blog_fixture()
  #      assert {:ok, %Blog{}} = Blogs.delete_blog(blog)
  #      assert_raise Ecto.NoResultsError, fn -> Blogs.get_blog!(blog.id) end
  #    end
  #
  #    test "change_blog/1 returns a blog changeset" do
  #      blog = blog_fixture()
  #      assert %Ecto.Changeset{} = Blogs.change_blog(blog)
  #    end
  #  end
end

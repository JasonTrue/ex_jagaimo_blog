defmodule ExJagaimoBlog.Factory do
  @moduledoc """
    Test fixtures
  """
  use ExMachina.Ecto, repo: ExJagaimoBlog.Repo

  def user_factory do
    %ExJagaimoBlog.Accounts.User{
      name: Faker.Person.name(),
      profile: Faker.Lorem.sentence(),
      email: sequence(:email, &"user#{&1}@example.com")
    }
  end

  def blog_factory do
    %ExJagaimoBlog.Blogs.Blog{
      name: Faker.Lorem.sentence(),
      host: Faker.Internet.domain_name()
    }
  end

  def post_factory do
    %ExJagaimoBlog.Blogs.Post{
      title: Faker.Lorem.sentence(),
      user: build(:user),
      blog: build(:blog),
      story: html_story(),
      approved: true,
      slug: Faker.Lorem.words(1..4) |> Enum.join("-"),
      alternate_id: nil,
      publish_at: DateTime.utc_now()
    }
  end

  def html_story do
    Faker.Lorem.paragraphs()
    |> Enum.map_join("\n\n", fn p -> "<p>#{p}</p>" end)
  end
end

defmodule ExJagaimoBlog.Release do
  @moduledoc """
    Runs ecto migrations and other release tasks
  """
  @app :ex_jagaimo_blog

  require Logger

  def migrate do
    print_context()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    print_context()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp print_context do
    config = Enum.into(ExJagaimoBlog.Repo.config(), %{})
    hostname = Map.get(config, :hostname, "???")
    database = Map.get(config, :database, "???")
    Logger.info("Postgres Host: #{hostname} DB: #{database}")
  end
end

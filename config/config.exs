# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ex_jagaimo_blog,
  ecto_repos: [ExJagaimoBlog.Repo]

config :ex_jagaimo_blog, ExJagaimoBlog.Repo,
  migration_timestamps: [type: :utc_datetime],
  migration_source: "phx_schema_migrations"

# Configures the endpoint
config :ex_jagaimo_blog, ExJagaimoBlogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "E3JB+ASCj288cNlnBdtSRYOE1CrQX9L8dY4db81AG/dtAXA/SrwH/wJkuEndUkcO",
  render_errors: [view: ExJagaimoBlogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExJagaimoBlog.PubSub,
  live_view: [signing_salt: "2ZIQenh4"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

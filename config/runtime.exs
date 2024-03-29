import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :ex_jagaimo_blog,
         ExJagaimoBlog.Repo,
         # ssl: true,
         url: database_url,
         pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :ex_jagaimo_blog,
         ExJagaimoBlogWeb.Endpoint,
         http: [
           port: String.to_integer(System.get_env("PORT") || "4000"),
           transport_options: [
             socket_opts: [:inet6]
           ]
         ],
         secret_key_base: secret_key_base,
         server: true
end

elastic_username = System.get_env("ELASTIC_USERNAME", "elastic")
elastic_password = System.get_env("ELASTIC_PASSWORD")
elastic_uri = System.get_env("ELASTIC_URI", "http://localhost:9200")

config :ex_jagaimo_blog,
       ExJagaimoBlog.Search.Cluster,
       url: elastic_uri,
       username: elastic_username,
       password: elastic_password

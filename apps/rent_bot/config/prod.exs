use Mix.Config

# Configure your database
config :rent_bot, RentBot.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  database: "",
  ssl: true,
  pool_size: 9

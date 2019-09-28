# Since configuration is shared in umbrella projects, this file
# should only configure the :five_card_draw application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :five_card_draw, FiveCardDraw.Repo,
  username: "postgres",
  password: "postgres",
  database: "five_card_draw_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

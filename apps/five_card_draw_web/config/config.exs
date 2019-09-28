# Since configuration is shared in umbrella projects, this file
# should only configure the :five_card_draw_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :five_card_draw_web,
  ecto_repos: [FiveCardDraw.Repo],
  generators: [context_app: :five_card_draw]

# Configures the endpoint
config :five_card_draw_web, FiveCardDrawWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2ahM6nCW/V2sGFc93VqYjr/e4yUlbSBqaL11ePIzwNMfBBt6yVZO+qjMBK58IJML",
  render_errors: [view: FiveCardDrawWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: FiveCardDrawWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

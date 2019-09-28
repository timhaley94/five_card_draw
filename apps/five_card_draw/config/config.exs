# Since configuration is shared in umbrella projects, this file
# should only configure the :five_card_draw application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :five_card_draw,
  ecto_repos: [FiveCardDraw.Repo]

import_config "#{Mix.env()}.exs"

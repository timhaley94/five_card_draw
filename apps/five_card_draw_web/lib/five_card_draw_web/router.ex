defmodule FiveCardDrawWeb.Router do
  use FiveCardDrawWeb, :router
  alias FiveCardDrawWeb.GameController

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FiveCardDrawWeb do
    pipe_through :api

    post "/game", GameController, :create
  end
end

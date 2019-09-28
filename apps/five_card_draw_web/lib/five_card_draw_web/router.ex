defmodule FiveCardDrawWeb.Router do
  use FiveCardDrawWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FiveCardDrawWeb do
    pipe_through :api
  end
end

defmodule FiveCardDraw.LobbyServer do
  alias FiveCardDraw.Lobby
  use GenServer

  # API

  # GenServer Callbacks
  @impl true
  def init(:ok) do
    {:ok, Lobby.new()}
  end

  defp format_reply(lobby) do
    {:reply, lobby, lobby}
  end

  @impl true
  def handle_call({:add_user}, _from, lobby) do
    lobby
    |> Lobby.add_user()
    |> format_reply()
  end

  @impl true
  def handle_call({:move, player_id, opts}, _from, lobby) do
    lobby
    |> Lobby.add_user(player_id, opts)
    |> format_reply()
  end
end

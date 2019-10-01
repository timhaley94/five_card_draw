defmodule FiveCardDraw.GameServer do
  alias FiveCardDraw.Lobby
  alias FiveCardDraw.GameRegistry
  use GenServer

  # API
  def start_link(id) do
    GenServer.start_link(__MODULE__, :ok, name: GameRegistry.via_tuple(id))
  end

  defp call(id, payload) do
    GameRegistry.via_tuple(id)
    |> GenServer.call(payload)
  end

  def get_state(id) do
    call(id, {:get_state})
  end

  def add_user(id) do
    call(id, {:add_user})
  end

  def move(id, user_id, data) do
    call(id, {:move, user_id, data})
  end

  # GenServer Callbacks
  @impl true
  def init(:ok) do
    {:ok, Lobby.new()}
  end

  defp format_reply(lobby) do
    {:reply, {:ok, lobby}, lobby}
  end

  @impl true
  def handle_call({:get_state}, _from, lobby) do
    lobby
    |> format_reply()
  end

  @impl true
  def handle_call({:add_user}, _from, lobby) do
    lobby
    |> Lobby.add_user()
    |> format_reply()
  end

  @impl true
  def handle_call({:move, user_id, data}, _from, lobby) do
    lobby
    |> Lobby.add_user(user_id, data)
    |> format_reply()
  end
end

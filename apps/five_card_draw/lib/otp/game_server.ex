defmodule FiveCardDraw.GameServer do
  alias FiveCardDraw.Game
  alias FiveCardDraw.GameRegistry
  use GenServer

  # API
  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: GameRegistry.via_tuple(id))
  end

  defp call(id, payload) do
    GameRegistry.via_tuple(id)
    |> GenServer.call(payload)
  end

  def get_state(id) do
    call(id, {:get_state})
  end

  def add_user(id, user_id) do
    call(id, {:add_user, user_id})
  end

  def start(id) do
    call(id, {:start})
  end

  def move(id, user_id, data) do
    call(id, {:move, user_id, data})
  end

  # GenServer Callbacks
  @impl true
  def init(id) do
    {:ok, Game.new(id)}
  end

  defp format_reply(game) do
    {:reply, {:ok, game}, game}
  end

  defp rescue_error(game, e) do
    IO.puts("An error occurred: " <> e.message)

    game
    |> format_reply()
  end

  @impl true
  def handle_call({:get_state}, _from, game) do
    game
    |> format_reply()
  end

  @impl true
  def handle_call({:add_user, user_id}, _from, game) do
    try do
      game
      |> Game.add_user(user_id)
      |> format_reply()
    rescue
      e -> rescue_error(game, e)
    end
  end

  @impl true
  def handle_call({:start}, _from, game) do
    try do
      game
      |> Game.start()
      |> format_reply()
    rescue
      e -> rescue_error(game, e)
    end
  end

  @impl true
  def handle_call({:move, user_id, data}, _from, game) do
    try do
      game
      |> Game.move(user_id, data)
      |> format_reply()
    rescue
      e -> rescue_error(game, e)
    end
  end
end

defmodule FiveCardDraw.GameSupervisor do
  alias __MODULE__
  use DynamicSupervisor

  # API
  def create_game() do

  end

  def start_link(_init_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # GenServer Callbacks
  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end

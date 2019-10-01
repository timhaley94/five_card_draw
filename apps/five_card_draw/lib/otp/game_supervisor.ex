defmodule FiveCardDraw.GameSupervisor do
  alias __MODULE__
  alias FiveCardDraw.GameServer
  import UUID
  use DynamicSupervisor

  # API
  def create_game() do
    id = uuid1()

    spec = %{
      id: GameServer,
      start: {GameServer, :start_link, [id]},
      restart: :transient,
    }

    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, spec)
    {:ok, id}
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

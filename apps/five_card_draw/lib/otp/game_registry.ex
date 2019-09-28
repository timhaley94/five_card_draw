defmodule FiveCardDraw.GameRegistry do
  use GenServer
  import UUID
  import ShorterMaps

  defp generate_id, do: uuid1()

  # API
  def register_pid(pid) do
    GenServer.call(__MODULE__, {:register_pid, pid})
  end

  def get_pid(id) do
    GenServer.call(__MODULE__, {:get_pid, id})
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # GenServer Callbacks
  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:register_pid, pid}, _from, ids) do
    id = uuid1()

    {:reply, {:ok, id}, Map.put(ids, id, pid)}
  end

  @impl true
  def handle_call({:get_pid, id}, _from, ids) do
    pid = Map.get(ids, id, nil)

    if not is_null(pid) do
      {:reply, {:ok, pid}, ids}
    else
      {:reply, {:error}, ids}
    end
  end
end

defmodule FiveCardDraw.UserServer do
  use GenServer
  import UUID
  import ShorterMaps

  defp generate_id, do: uuid1()
  defp generate_token, do: uuid1()

  # API
  def add_user() do
    {:ok, GenServer.call(__MODULE__, {:add_user})}
  end

  def auth_user(opts) do
    {GenServer.call(__MODULE__, {:auth_user, opts})}
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
  def handle_call({:add_user}, _from, users) do
    user = %{
      id: generate_id(),
      token: generate_token(),
    }

    {:reply, user, Map.put(users, user.id, user)}
  end

  @impl true
  def handle_call({:auth_user, ~M{id, token}}, _from, users) do
    t = users
    |> Map.get(id, %{})
    |> Map.get(:token, nil)

    if t == token do
      {:reply, :ok, users}
    else
      {:reply, :error, users}
    end
  end

  @impl true
  def handle_call({:auth_user, _opts}, _from, users) do
    {:reply, :error, users}
  end
end

defmodule FiveCardDraw.Lobby do
  alias __MODULE__
  alias FiveCardDraw.Game
  import UUID
  import ShorterMaps

  @minimum_users 2
  @maximum_users 6

  @enforce_keys [:id]
  defstruct(
    id: nil,
    game: nil,
    stats: [],
    users: [],
  )

  defguard is_full(value) when length(value) >= @maximum_users

  defp generate_id, do: uuid1()

  def can_start?(~M{%Lobby users}) do
    length(users) >= @minimum_users
  end

  def full?(~M{%Lobby users}) when is_full(users), do: true
  def full?(_lobby), do: false

  defp start_game(lobby = ~M{%Lobby users}) when is_full(users) do
    lobby
    |> Map.put(:game, Game.new(users))
  end

  defp start_game(lobby = %Lobby{}), do: lobby

  defp end_game(lobby = ~M{%Lobby game}) do
    if Game.is_finished?(game) do
      lobby
      |> Map.update!(:stats, fn x -> x ++ [Game.stats(game)] end)
      |> start_game()
    else
      lobby
    end
  end

  def move(lobby = ~M{%Lobby game}, player_id, opts) when not is_nil(game) do
    lobby
    |> Map.put(:game, Game.move(game, player_id, opts))
    |> end_game()
  end

  def move(lobby), do: lobby

  def add_user(lobby = ~M{%Lobby users}) when not is_full(users) do
    lobby
    |> Map.put(:users, users ++ [generate_id()])
    |> start_game()
  end

  def new() do
    %Lobby{
      id: generate_id()
    }
  end
end

defmodule FiveCardDraw.Game do
  alias __MODULE__
  alias FiveCardDraw.Round
  alias FiveCardDraw.Player
  import ShorterMaps

  @minimum_users 2
  @maximum_users 6

  @enforce_keys [:id]
  defstruct(
    id: nil,
    round: nil,
    players: [],
    is_finished?: false
  )

  defguardp has_quorum(players) when length(players) >= @minimum_users
  defguardp is_full(players) when length(players) >= @maximum_users

  defp is_joinable?(~M{%Game players, round: nil, is_finished?: false}) when has_quorum(players), do: true
  defp is_joinable?(_), do: false

  def start(game = ~M{%Game players, round: nil}) when has_quorum(players) do
    game
    |> Map.put(:round, Round.new(players))
  end

  defp start_if_full(game = ~M{%Game players}) when is_full(players), do: start(game)
  defp start_if_full(game = %Game{}), do: game

  def add_user(game = %Game{}, user_id) do
    if is_joinable?(game) do
      game
      |> Map.update!(:players, fn x -> [Player.new(user_id) | x] end)
      |> start_if_full()
    else
      game
    end
  end

  # defp start_game(lobby = ~M{%Lobby users}) when is_full(users) do
  #   lobby
  #   |> Map.put(:game, Game.new(users))
  # end
  #
  # defp start_game(game = %Game{}), do: game
  #
  # defp end_game(game = %Game{}) do
  #   game
  # end

  defp check_for_round_end(game = ~M{%Game round}) do
    if Round.finished?(round) do
      game
    else
      game
    end
  end

  def move(game = ~M{%Game round, is_finished?: false}, user_id, opts) when not is_nil(round) do
    game
    |> Map.put(:round, Round.move(round, Map.put(opts, :player_id, user_id)))
    |> check_for_round_end()
  end

  def move(game, _user_id, _opts), do: game

  def new(id) do
    %Game{
      id: id
    }
  end
end

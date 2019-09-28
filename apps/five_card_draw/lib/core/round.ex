defmodule FiveCardDraw.Round do
  alias __MODULE__
  alias FiveCardDraw.Player
  alias FiveCardDraw.ListUtils
  import ShorterMaps

  @stages [
    :ante,
    :bet_1,
    :call_1,
    :draw,
    :bet_2,
    :call_2,
  ]

  @betting_rounds [:bet_1, :bet_2]
  @call_rounds [:call_1, :call_2]

  @first_stage List.first(@stages)
  @last_stage List.last(@stages)

  @enforce_keys [:active_ids, :players]
  defstruct(
    finished?: false,
    stage: @first_stage,
    current_id: nil,
    active_ids: [],
    players: %{}
  )

  defp advance_stage(round = %Round{}) do
    round
    |> Map.update!(:stage, fn x -> ListUtils.next_value(@stages, x) end)
  end

  defp advance_current_id(round = ~M{%Round stage, active_ids}) when stage in @betting_rounds do
    round
    |> Map.update!(:current_id, fn x ->
      ListUtils.next_value(active_ids, x)
    end)
  end

  defp advance_current_id(round = ~M{%Round stage}) when stage in @call_rounds do
    cb = current_bet(round)

    next_id = round
    |> active_players()
    |> Enum.find(fn x -> not Player.matches_bet?(x, cb) end)
    |> Map.fetch!(:id)

    Map.put(round, :current_id, next_id)
  end

  defp advance_current_id(round = %Round{}), do: round

  defp reset_current_id(round = ~M{%Round active_ids}) do
    round
    |> Map.put(:current_id, List.first(active_ids))
  end

  defp remove_id(round = %Round{}, id) do
    round
    |> Map.update!(:active_ids, fn x ->
      Enum.reject(x, fn y -> y == id end)
    end)
  end

  defp update_player(round = %Round{}, player_id, func) do
    round
    |> Map.update!(:players, fn players ->
      Map.update!(players, player_id, fn player ->
        func.(player)
      end)
    end)
  end

  defp deal_hands(round = %Round{}) do
    round
    |> Map.update!(:players, fn players ->
      players
      |> Enum.map(fn {id, player} -> {id, Player.deal(player)} end)
      |> Map.new()
    end)
  end

  defp action(round = ~M{%Round current_id: player_id}, ~M{player_id, action: :fold}) do
    round
    |> advance_current_id()
    |> remove_id(player_id)
  end

  defp action(round = %Round{}, ~M{player_id, action: :fold}) do
    round
    |> remove_id(player_id)
  end

  defp action(round = ~M{%Round stage: :ante}, ~M{player_id}) do
    round
    |> update_player(player_id, &Player.ante/1)
  end

  defp action(round = ~M{%Round stage: :draw}, ~M{player_id, ids_to_discard}) do
    round
    |> update_player(player_id, fn x ->
      Player.draw(x, ids_to_discard)
    end)
  end

  defp action(round = ~M{%Round stage, current_id: player_id}, opts = ~M{player_id, action: :call}) when stage in @betting_rounds do
    o = opts
    |> Map.put(:action, :raise)
    |> Map.put(:amount, 0)

    action(round, o)
  end

  defp action(round = ~M{%Round stage, current_id: player_id}, ~M{player_id, amount, action: :raise}) when stage in @betting_rounds do
    round
    |> advance_current_id()
    |> update_player(player_id, fn x ->
      Player.bet(x, amount + current_bet(round))
    end)
  end

  defp action(round = ~M{%Round stage, current_id: player_id}, ~M{player_id}) when stage in @call_rounds do
    round
    |> advance_current_id()
    |> update_player(player_id, fn x ->
      Player.bet(x, current_bet(round))
    end)
  end

  defp action(round = %Round{}, _context), do: round

  defp current_bet(round = %Round{}) do
    round
    |> active_players()
    |> Enum.map(&Player.current_bet/1)
    |> Enum.max()
  end

  defp active_players(~M{%Round active_ids, players}) do
    active_ids
    |> Enum.map(fn id ->
      Map.fetch!(players, id)
    end)
  end

  defp all_players_anted?(round = %Round{}) do
    round
    |> active_players()
    |> Enum.all?(&Player.anted?/1)
  end

  defp all_players_drew?(round = %Round{}) do
    round
    |> active_players()
    |> Enum.all?(&Player.drew?/1)
  end

  defp should_skip_call_round?(round = %Round{}) do
    cb = current_bet(round)

    round
    |> active_players()
    |> Enum.all?(fn x -> Player.matches_bet?(x, cb) end)
  end

  defp update_meta(round = ~M{%Round stage: :ante, players}) do
    if all_players_anted?(round) do
      round
      |> advance_stage()
      |> reset_current_id()
      |> deal_hands()
    else
      round
    end
  end

  defp update_meta(round = ~M{%Round stage, current_id: nil}) when stage in @betting_rounds do
    if should_skip_call_round?(round) do
      round
      |> advance_stage()
      |> advance_stage()
    else
      round
      |> advance_stage()
      |> reset_current_id()
    end
  end

  defp update_meta(round = ~M{%Round stage, current_id: nil}) when stage in @call_rounds do
    round
    |> advance_stage()
  end

  defp update_meta(round = ~M{%Round stage: :draw}) do
    if all_players_drew?(round) do
      round
      |> advance_stage()
      |> reset_current_id()
    else
      round
    end
  end

  defp update_meta(round = %Round{}), do: round

  defp mark_winners(round = %Round{}) do
    if length(round.active_ids) <= 1 or is_nil(round.stage) do
      round
      |> Map.put(:finished?, true)
    else
      round
    end
  end

  def move(round = %Round{}, context) do
    round
    |> action(context)
    |> update_meta()
    |> mark_winners()
  end

  def awaiting_ids(round = ~M{%Round stage: :ante}) do
    round
    |> active_players()
    |> Enum.reject(&Player.anted?/1)
    |> Enum.map(fn x -> x.id end)
  end

  def awaiting_ids(round = ~M{%Round stage: :draw}) do
    round
    |> active_players()
    |> Enum.filter(&Player.drew?/1)
    |> Enum.map(fn x -> x.id end)
  end

  def awaiting_ids(round = ~M{%Round stage, current_id}) when stage in @betting_rounds do
    [current_id]
  end

  def awaiting_ids(round = ~M{%Round stage, current_id}) when stage in @call_rounds do
    [current_id]
  end

  def active_ids(~M{%Round active_ids}), do: active_ids

  def new(players) when is_list(players) do
    %Round{
      players: Map.new(players, fn x -> {x.id, x} end),
      active_ids: Enum.map(players, fn x -> x.id end)
    }
  end
end

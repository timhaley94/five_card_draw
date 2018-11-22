defmodule FiveCardDraw.Round do
  alias __MODULE__
  import ListUtils

  @stages [
    :ante,
    :bet_1,
    :draw,
    :bet_2
  ]

  @betting_stages [:ante, :bet_1, :bet_2]

  @first_stage List.first(@stages)
  @last_stage List.last(@stages)

  @enforce_keys [:players]
  defstruct(
    finished?: false,
    stage: @first_stage,
    player_ids: %MapSet{},
    play_order: [],
    hands: %{},
    pot: %Pot{}
  )

  defp first_player_id(round) do
    round
    |> get_ids()
    |> List.first()
  end

  defp next_player_id(round, player_id) do
    round
    |> get_ids()
    |> ListUtils.next_value(player_id)
  end

  defp advance_next_player(round, nil) do
    round
    |> advance_stage()
    |> Map.put(:current_player_id, first_player_id(round))
  end

  defp advance_next_player(round, next_player_id) do
    round
    |> Map.put(current_player_id: next_player_id)
  end

  defp advance_next_player(round = %Round{ current_player_id: current }) do
    round
    |> advance_next_player(next_player_id(current))
  end

  defp init_players(players) do
    players
    |> Enum.map(fn player -> Map.put(player, :hand, Hand.new()) end)
  end

  def init(players) do
    %Round{
      players: init_players(players)
    }
    |> Map.put(:current_player_id, first_player_id(round))
  end
end



### New attempt August 4th, 2018

defp next_stage(stage), do: ListUtils.next_value(@stages, stage)

defp advance_stage(round = %Round{ stage: :ante }) do
  round
  |> deal_hands()
  |> Map.update!(:stage, &next_stage/1)
end

defp advance_stage(round = ~M{ %Round, stage }) when stage == @last_stage do
  round
  |> Map.put(:finished?, true)
end

defp advance_stage(round = %Round{}) do
  round
  |> Map.update!(:stage, &next_stage/1)
end

# Handle Bet functionality start
defp update_stage_after_bet(round = %Round{}, ~M{ old_round }) do
  if round.pot.finished? or round.pot.current_round > old_round do
    advance_stage(round)
  else
    round
  end
end

defp deal_hands(round = ~M{ %Round, player_ids }) do
  round
  |> Map.put(:hands, deal_hands(player_ids))
end

defp deal_hands(player_ids = %MapSet{}) do
  player_ids
  |> MapSet.to_list()
  |> Enum.map(&Hand.new/0)
end

defp bet(round = %Round{}, context) do
  round
  |> Map.update!(:pot, &(Pot.move(&1, context)))
end

defp handle_bet(round = %Round{}, context) do
  round
  |> bet(context)
  |> update_stage_after_bet(%{ old_round: round.pot.current_round })
end
# Handle Bet functionality end

# Handle Draw functionality start
defp all_hands_exchanged?(round = ~M{ %Round, hands }) do
  hands
  |> Enum.all?(fn ({ _id, hand }) -> hand.exchanged? end)
end

defp update_stage_after_draw(round = %Round{}) do
  if all_hands_exchanged?(round) do
    advance_stage(round)
  else
    round
  end
end

defp draw(round = %Round{}, ~M{ player_id, ids_to_discard }) do
  round
  |> update_in([:hands, player_id], &(Hand.exchange(&1, ids_to_discard)))
end

defp hangle_draw(round = %Round{}, context) do
  round
  |> draw(context)
  |> update_stage_after_draw()
end
# Handle Draw functionality end

defp move_handler(:ante), do: &handle_ante/2
defp move_handler(:bet_1), do: &handle_bet/2
defp move_handler(:draw), do: &handle_draw/2
defp move_handler(:bet_2), do: &handle_bet/2

def move(round = ~M{ %Round, current_player_id: current, stage }, ~M{ player_id: current, context }) do
  move_handler(stage).(round, context)
end

def move(round = %Round{}, _opts), do: round

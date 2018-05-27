# defmodule FiveCardDraw.Round do
#   alias __MODULE__
#   import ListUtils
#
#   @stages [
#     :betting_1,
#     :draw,
#     :betting_2
#   ]
#
#   @betting_stages [:betting_1, :betting_2]
#   @draw_stages [:draw]
#
#   @first_stage List.first(@stages)
#   @last_stage List.last(@stages)
#
#   @enforce_keys [:players]
#   defstruct(
#     finished?: false,
#     stage: @first_stage,
#     current_player_id: nil,
#     players: []
#   )
#
#   defp next_stage(stage), do: ListUtils.next_value(@stages, stage)
#
#   defp advance_stage(round = %Round{ stage: stage }) when stage == @last_stage do
#     round
#     |> Map.put(:finished?, true)
#   end
#
#   defp advance_stage(round = %Round{ stage: stage }) do
#     round
#     |> Map.put(:stage, next_stage(stage))
#   end
#
#   defp get_ids(%Round{ players: players }) do
#     players
#     |> Enum.map(fn x -> x.id end)
#   end
#
#   defp first_player_id(round) do
#     round
#     |> get_ids()
#     |> List.first()
#   end
#
#   defp next_player_id(round, player_id) do
#     round
#     |> get_ids()
#     |> ListUtils.next_value(player_id)
#   end
#
#   defp advance_next_player(round, nil) do
#     round
#     |> advance_stage()
#     |> Map.put(:current_player_id, first_player_id(round))
#   end
#
#   defp advance_next_player(round, next_player_id) do
#     round
#     |> Map.put(current_player_id: next_player_id)
#   end
#
#   defp advance_next_player(round = %Round{ current_player_id: current }) do
#     round
#     |> advance_next_player(next_player_id(current))
#   end
#
#   def handle_move(round = %Round{ current_player_id: current }, %{ player_id: current, context: context }) do
#
#   end
#
#   def bet(round = %Round{ stage: stage }, opts) when stage in @betting_stages do
#
#   end
#
#   def bet(round, _opts), do: round
#
#   def draw(round = %Round{ stage: stage }, opts) when stage in @draw_stages do
#     game
#     |>
#   end
#
#   defp init_players(players) do
#     players
#     |> Enum.map(fn player -> Map.put(player, :hand, Hand.new()) end)
#   end
#
#   def init(players) do
#     %Round{
#       players: init_players(players)
#     }
#     |> Map.put(:current_player_id, first_player_id(round))
#   end
# end

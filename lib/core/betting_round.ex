# defmodule FiveCardDraw.BettingRound do
#   alias __MODULE__
#   alias FiveCardDraw.TupleUtils
#
#   @stages [:primary, :secondary, :complete]
#
#   @enforce_keys [:stage, :next_player_id, :bets]
#   defstruct(
#     stage: :primary,
#     current_bet: 0,
#     next_player_id: nil,
#     player_ids: nil
#   )
#
#   defp players_turn?(%BettingRound{ next_player_id: next_player_id }, player_id) do
#     quote do
#       unquote(next_player_id) === unquote(player_id)
#     end
#   end
#
#   defp inc_next_player_id(round = %BettingRound{ player_ids: player_ids, next_player_id: next_player_id }) do
#     round
#     |> Map.put(:next_player_id, TupleUtils.next_value(player_ids, next_player_id))
#   end
#
#   def fold_player() do
#     round
#     |>
#   end
#
#   def take_turn(round, player_id, {:fold}) when players_turn?(round, player_id) do
#     round
#     |> fold_player(round, player_id)
#   end
#
#   def new(player_ids = [next_player_id|_rest]) do
#     %BettingRound{
#       player_ids: List.to_tuple(player_ids),
#       next_player: next_player_id
#     }
#   end
# end

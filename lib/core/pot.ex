# defmodule FiveCardDraw.Pot do
#   alias __MODULE__
#
#   players {
#     remaining_money:
#     current_bet:
#   }
#
#   @enforce_keys [:number_of_rounds, :current_round, :players]
#   defstruct(
#     number_of_rounds: 2,
#     current_round: 1,
#     current_player_id: nil,
#     total: 0,
#     lead_bet: 0,
#     players: []
#   )
#
#   def bet(%Pot{ current_bet: current_bet }, player_id) do
#
#   end
#
#   def bet(player_id), do:
#
#   defp update_meta_data(pot) do
#     pot
#     |>
#   end
#
#   defp player_is_all_in?(%{ available: current, current_bet: current }), do: true
#   defp player_is_all_in?(_player), do: false
#
#   def finished?(%Pot{ number_of_rounds: max, current_round: current }) when current > max, do: true
#   def finished?(%Pot{ players: players }) do
#     players
#     |> Enum.any?(&player_is_all_in?/1)
#   end
#
#   def new(players, %{ number_of_rounds: max, current_round: current }) do
#     %Pot{
#       number_of_rounds: max,
#       current_round: current,
#     }
#     |> update_meta_data()
#   end
# end

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
#   defp lead_bet(%Pot{ players: players }) do
#     players
#     |> Enum.sort_by(fn x -> x.current_bet end)
#     |> Enum.reverse
#     |> List.first()
#     |> Map.get(:current_bet)
#   end
#
#   defp previous_player do
#
#   end
#
#   defp current_player do
#
#   end
#
#   defp player_is_all_in?(%{ available: current, current_bet: current }), do: true
#   defp player_is_all_in?(_player), do: false
#
#   def finished?(%Pot{ number_of_rounds: max, current_round: current }), do: current > max
#   def finished?()
#
#   defp init_player_maps(pa)
#
#   def new(players, %{ number_of_rounds: max, current_round: current }) do
#     %Pot{
#       number_of_rounds: max,
#       current_round: current,
#     }
#     |> update_meta_data()
#   end
# end

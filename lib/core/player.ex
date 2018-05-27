# defmodule FiveCardDraw.Player do
#   alias __MODULE__
#
#   @enforce_keys [:id, :purse, :hand]
#   defstruct(
#     id: nil,
#     purse: nil,
#     hand: nil
#   )
#
#   def all_in?(%Purse{ current_bet: current, available_money: available }) do
#     current >= available
#   end
#
#   def broke?(%Player{ purse: purse }), do: Purse.broke?(purse)
#
#   def bet(purse = %Purse{ current_bet: current, available_money: available }, bet) when current + bet <= available do
#     purse
#     |> Map.put(:current_bet, current + bet)
#   end
#
#   def resolve_hand(player, winnings) do
#     purse
#     |> Map.put(:current_bet, 0)
#     |> Map.put(:available_money, max(available + (winnings - current), 0))
#   end
#
#   defp new_hand(player) do
#     player
#     |> Map.put(:hand, Hand.new())
#   end
#
#   def new(%{ id: id }) do
#     %Player{
#       id: id,
#       purse: Purse.new(),
#       hand: Hand.new()
#     }
#   end
#
#   def new(_opts), do: new(%{ id: generate_id() })
# end

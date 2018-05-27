defmodule FiveCardDraw.Purse do
  alias __MODULE__

  @starting_cash 1000

  defstruct(
    available_money: @starting_cash,
    current_bet: 0
  )

  def all_in?(%Purse{ current_bet: current, available_money: available }) do
    current >= available
  end

  def broke?(%Purse{ available_money: available }), do: available <= 0

  def starting_cash(), do: @starting_cash

  def bet(purse = %Purse{ current_bet: current, available_money: available }, bet) when current + bet <= available do
    purse
    |> Map.put(:current_bet, current + bet)
  end

  def resolve_bet(purse = %Purse{ current_bet: current, available_money: available }, winnings) do
    purse
    |> Map.put(:current_bet, 0)
    |> Map.put(:available_money, max(available + (winnings - current), 0))
  end

  def new(%{ available_money: available_money }) when not is_nil(available_money) do
    %Purse{
      available_money: available_money
    }
  end

  def new(_opts), do: new()
  def new(), do: %Purse{}
end

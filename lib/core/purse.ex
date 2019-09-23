defmodule FiveCardDraw.Purse do
  alias __MODULE__
  import ShorterMaps

  @starting_cash 1000

  defstruct(
    available_money: @starting_cash,
    current_bet: 0
  )

  def all_in?(~M{%Purse current_bet, available_money}) do
    current_bet >= available_money
  end

  def broke?(~M{%Purse available_money}), do: available_money <= 0

  def starting_cash(), do: @starting_cash

  def available_money(~M{%Purse available_money}), do: available_money

  def current_bet(~M{%Purse current_bet}), do: current_bet

  def bet(purse = ~M{%Purse current_bet, available_money}, bet) when bet >= current_bet do
    purse
    |> Map.put(:current_bet, min(bet, available_money))
  end

  def resolve_bet(purse = ~M{%Purse current_bet, available_money}, winnings) do
    purse
    |> Map.put(:current_bet, 0)
    |> Map.put(:available_money, max(available_money + winnings - current_bet, 0))
  end

  def new(~M{available_money}) when not is_nil(available_money) do
    %Purse{
      available_money: available_money
    }
  end

  def new(_opts), do: new()
  def new(), do: %Purse{}
end

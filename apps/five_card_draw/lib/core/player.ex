defmodule FiveCardDraw.Player do
  alias __MODULE__
  alias FiveCardDraw.Purse
  alias FiveCardDraw.Hand
  import ShorterMaps

  @ante_value 5

  @enforce_keys [:id, :purse]
  defstruct(
    id: nil,
    anted?: false,
    hand: nil,
    purse: nil
  )

  def ante(player = %Player{ anted?: false }) do
    player
    |> Map.put(:anted?, true)
    |> bet(@ante_value)
  end

  def ante(player), do: player

  def anted?(~M{%Player anted?}), do: anted?

  def deal(player = %Player{ hand: nil }) do
    player
    |> Map.put(:hand, Hand.new())
  end

  def deal(player = %Player{}), do: player

  def draw(player = %Player{ hand: nil }, _ids), do: player

  def draw(player = ~M{%Player hand}, ids_to_discard) do
    player
    |> Map.put(:hand, Hand.exchange(hand, ids_to_discard))
  end

  def drew?(%Player{ hand: nil }), do: false
  def drew?(~M{%Player hand}), do: Hand.exchanged?(hand)

  def bet(player = %Player{ anted?: true }, bet) do
    player
    |> Map.update!(:purse, fn purse ->
      Purse.bet(purse, bet)
    end)
  end

  def bet(player = %Player{}, _bet), do: player

  def hand(~M{%Player hand}), do: hand
  def bankroll(~M{%Player purse}), do: Purse.available_money(purse)
  def current_bet(~M{%Player purse}), do: Purse.current_bet(purse)
  def all_in?(~M{%Player purse}), do: Purse.all_in?(purse)
  def matches_bet?(player = %Player{}, bet) do
    Player.all_in?(player) or (Player.current_bet(player) <= bet)
  end

  def resolve_round(player = %Player{}, winnings) do
    player
    |> Map.put(:anted?, false)
    |> Map.put(:hand, nil)
    |> Map.update!(:purse, fn purse ->
      Purse.resolve_bet(purse, winnings)
    end)
  end

  def new(id) do
    %Player{
      id: id,
      purse: Purse.new(),
    }
  end
end

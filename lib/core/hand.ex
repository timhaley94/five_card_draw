defmodule FiveCardDraw.Hand do
  alias __MODULE__
  alias FiveCardDraw.Card

  @num_of_cards 5
  @max_num_discardable 3

  @enforce_keys [:cards, :exchanged?]
  defstruct(
    cards: [],
    exchanged?: false
  )

  defp new_hand() do
    %Hand{
      cards: [],
      exchanged?: false
    }
  end

  defp new_card(_x), do: Card.new()

  defp new_cards(num_to_draw) do
    Enum.map(1..num_to_draw, &new_card/1)
  end

  # Start discard functionality
  defp drop_cards(cards, ids_to_discard) do
    cards
    |> Enum.reject(fn x -> Enum.member?(ids_to_discard, x.id) end)
  end

  defp discard(hand = %Hand{}, ids_to_discard) do
    hand
    |> Map.update!(:cards, fn cards -> drop_cards(cards, ids_to_discard) end)
  end
  # End discard functionality

  # Start draw functionality
  defp num_of_missing_cards(cards) do
    @num_of_cards - length(cards)
  end

  defp get_missing_cards(cards) do
    cards
    |> num_of_missing_cards()
    |> new_cards()
  end

  defp fill_missing_cards(cards) do
    cards ++ get_missing_cards(cards)
  end

  defp draw(hand = %Hand{}) do
    hand
    |> Map.update!(:cards, &fill_missing_cards/1)
  end
  # End draw functionality

  def num_of_cards(), do: @num_of_cards
  def max_num_discardable(), do: @max_num_discardable

  def card_rank_ints(%Hand{ cards: cards }) do
    cards
    |> Enum.map(&Card.rank_int/1)
    |> Enum.sort()
    |> Enum.reverse()
  end

  def exchange(hand = %Hand{ exchanged?: false }, []) do
    hand
    |> Map.put(:exchanged?, true)
  end

  def exchange(hand = %Hand{ exchanged?: false }, ids_to_discard) when length(ids_to_discard) <= @max_num_discardable do
    hand
    |> discard(ids_to_discard)
    |> draw()
    |> Map.put(:exchanged?, true)
  end

  def new do
    new_hand()
    |> draw()
  end
end

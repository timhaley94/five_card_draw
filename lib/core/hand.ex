defmodule FiveCardDraw.Hand do
  alias __MODULE__
  alias FiveCardDraw.Card

  @max_num_of_cards 5

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
    @max_num_of_cards - length(cards)
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

  def exchange(hand = %Hand{}, ids_to_discard) do
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

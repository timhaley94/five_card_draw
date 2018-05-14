defmodule FiveCardDraw.HandTest do
  use ExUnit.Case
  alias FiveCardDraw.Hand
  alias FiveCardDraw.Card

  test "new sets exchanged? to false" do
    assert not Hand.new().exchanged?
  end

  test "new sets cards to list with appropriate length" do
    assert length(Hand.new().cards) == Hand.num_of_cards()
  end

  defp test_hand(), do: test_hand(false)
  defp test_hand(exchanged?) do
    cards = 1..Hand.num_of_cards()
    |> Enum.map(fn n -> Map.put(Card.new(), :id, to_string(n)) end)

    %Hand{
      cards: cards,
      exchanged?: exchanged?
    }
  end

  defp assert_exchanged(hand = %Hand{ exchanged?: exchanged? }) do
    assert exchanged?

    hand
  end

  defp assert_dropped_cards(hand = %Hand{ cards: cards }, ids_to_discard) do
    cards
    |> Enum.all?(fn card -> not Enum.member?(ids_to_discard, card.id) end)
    |> assert()

    hand
  end

  defp assert_exchange_success(ids_to_discard) do
    assert_exchange_success(ids_to_discard, false)
  end

  defp assert_exchange_success(ids_to_discard, already_exchanged?) do
    test_hand(already_exchanged?)
    |> Hand.exchange(ids_to_discard)
    |> assert_exchanged()
    |> assert_dropped_cards(ids_to_discard)
  end

  defp assert_exchange_raise(ids_to_discard) do
    assert_exchange_raise(ids_to_discard, false)
  end

  defp assert_exchange_raise(ids_to_discard, already_exchanged?) do
    assert_raise(FunctionClauseError, fn ->
      test_hand(already_exchanged?)
      |> Hand.exchange(ids_to_discard)
    end)
  end

  test "exchange can handle we no cards are to be discarded" do
    assert_exchange_success []
  end

  test "exchange throws if more cards are to be discarded than are allowed" do
    assert_exchange_raise ["1", "2", "3", "4"]
  end

  test "exchange can handle we a legal amount of cards are to be discarded" do
    assert_exchange_success ["1", "2", "3"]
  end

  test "exchange throws if hand has already exchanged, even if list is empty" do
    assert_exchange_raise([], true)
  end

  test "exchange throws if hand has already exchanged, even if list is illegal" do
    assert_exchange_raise(["1", "2", "3", "4"], true)
  end

  test "exchange throws if hand has already exchanged, even if list is legal" do
    assert_exchange_raise(["1", "2", "3"], true)
  end

  defp card_rank_ints(n) do
    test_hand(true)
    |> Map.update!(:cards, fn cards -> Enum.map(cards, fn card -> Map.put(card, :rank, n) end) end)
    |> Hand.card_rank_ints()
  end

  test "card_rank_ints returns list of ints" do
    card_rank_ints(:five)
    |> Enum.each(fn n -> assert is_integer(n) end)
  end

  test "card_rank_ints maps higher cards to higher ints" do
    [card_rank_ints(:five), card_rank_ints(:three)]
    |> Enum.zip()
    |> Enum.each(fn {a, b} -> assert a > b end)
  end
end

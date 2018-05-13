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

  test "foo 1" do
    assert_exchange_success []
  end

  test "foo 2" do
    assert_exchange_raise ["1", "2", "3", "4"]
  end

  test "foo 3" do
    assert_exchange_success ["1", "2", "3"]
  end

  test "foo 4" do
    assert_exchange_raise([], true)
  end

  test "foo 5" do
    assert_exchange_raise(["1", "2", "3", "4"], true)
  end

  test "foo 6" do
    assert_exchange_raise(["1", "2", "3"], true)
  end

  # defp rank_int(rank) do
  #   %Card{ id: "1", rank: rank, suit: :hearts }
  #   |> Card.rank_int()
  # end
  #
  # test "rank_int returns higher value for queen than three" do
  #   assert rank_int(:three) < rank_int(:queen)
  # end
  #
  # test "rank_int returns higher value for ace than queen" do
  #   assert rank_int(:queen) < rank_int(:ace)
  # end
  #
  # test "new generates id" do
  #   assert Card.new().id != nil
  # end
end

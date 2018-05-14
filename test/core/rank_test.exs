defmodule FiveCardDraw.RankTest do
  use ExUnit.Case
  import UUID
  alias FiveCardDraw.Rank
  alias FiveCardDraw.Hand
  alias FiveCardDraw.Card

  defp test_cards(card_config) do
    card_config
    |> Enum.map(fn ({rank, suit}) -> %Card{ id: uuid1(), rank: rank, suit: suit } end)
  end

  defp test_hand(card_config) do
    %Hand{
      cards: test_cards(card_config),
      exchanged?: true
    }
  end

  defp assert_rank(hand, expected) do
    assert Rank.rank(hand) == expected
  end

  defp high_card(), do: high_card(:ace)
  defp high_card(a), do: high_card(a, :ten, :nine, :four, :two)
  defp high_card(a, b, c, d, e) do
    test_hand(
      [{a, :hearts},
       {a, :spades},
       {b, :diamonds},
       {c, :spades},
       {d, :spades}]
    )
  end

  defp one_pair(), do: one_pair(:two, :five, :king, :seven)
  defp one_pair(a, b, c, d) do
    test_hand(
      [{a, :hearts},
       {a, :spades},
       {b, :diamonds},
       {c, :spades},
       {d, :spades}]
    )
  end

  defp two_pair(), do: two_pair(:two, :king, :seven)
  defp two_pair(a, b, c) do
    test_hand(
      [{a, :hearts},
       {a, :spades},
       {b, :diamonds},
       {b, :spades},
       {c, :spades}]
    )
  end

  defp three_of_a_kind(), do: three_of_a_kind(:two, :king, :seven)
  defp three_of_a_kind(a, b, c) do
    test_hand(
      [{a, :hearts},
       {a, :spades},
       {a, :diamonds},
       {b, :spades},
       {c, :spades}]
    )
  end

  defp straight(), do: straight(:two, :three, :four, :five, :six)
  defp straight(a, b, c, d, e) do
    test_hand(
      [{a, :hearts},
       {b, :spades},
       {c, :diamonds},
       {d, :spades},
       {e, :spades}]
    )
  end

  defp flush(), do: flush(:two, :three, :five, :king, :seven)
  defp flush(a, b, c, d, e) do
    test_hand(
      [{a, :hearts},
       {b, :hearts},
       {c, :hearts},
       {d, :hearts},
       {e, :hearts}]
    )
  end

  defp full_house(), do: full_house(:two, :king)
  defp full_house(a, b) do
    test_hand(
      [{a, :hearts},
       {a, :spades},
       {a, :diamonds},
       {b, :spades},
       {b, :spades}]
    )
  end

  defp four_of_a_kind(), do: four_of_a_kind(:two, :king)
  defp four_of_a_kind(a, b) do
    test_hand(
      [{a, :hearts},
       {a, :spades},
       {a, :diamonds},
       {a, :spades},
       {b, :spades}]
    )
  end

  defp straight_flush(), do: straight_flush(:two, :three, :four, :five, :six)
  defp straight_flush(a, b, c, d, e) do
    flush(a, b, c, d, e)
  end

  defp five_of_a_kind(), do: five_of_a_kind(:two)
  defp five_of_a_kind(a) do
    test_hand(
      [{a, :hearts},
       {a, :spades},
       {a, :diamonds},
       {a, :spades},
       {a, :spades}]
    )
  end

  test "foo 0" do
    assert_rank(high_card(), :high_card)
  end

  test "foo 1" do
    assert_rank(one_pair(), :one_pair)
  end

  test "foo 2" do
    assert_rank(two_pair(), :two_pair)
  end

  test "foo 3" do
    assert_rank(three_of_a_kind(), :three_of_a_kind)
  end

  test "foo 4" do
    assert_rank(straight(), :straight)
  end

  test "foo 5" do
    assert_rank(flush(), :flush)
  end

  test "foo 6" do
    assert_rank(full_house(), :full_house)
  end

  test "foo 7" do
    assert_rank(four_of_a_kind(), :four_of_a_kind)
  end

  test "foo 8" do
    assert_rank(straight_flush(), :straight_flush)
  end

  test "foo 9" do
    assert_rank(five_of_a_kind(), :five_of_a_kind)
  end

  defp assert_best_hand(loser, winner) do
    assert Rank.best_hand([loser, winner]) == [winner]
  end

  test "bar 0" do
    assert_best_hand(
      high_card(),
      one_pair()
    )
  end

  test "bar 1" do
    assert_best_hand(
      three_of_a_kind(),
      straight()
    )
  end

  test "bar 2" do
    assert_best_hand(
      straight(),
      flush()
    )
  end

  test "bar 3" do
    assert_best_hand(
      flush(),
      four_of_a_kind()
    )
  end

  test "bar 4" do
    assert_best_hand(
      four_of_a_kind(),
      straight_flush()
    )
  end

  test "baz 1" do
    assert_best_hand(
      high_card(:king),
      high_card(:ace)
    )
  end

  test "baz 2" do
    assert_best_hand(
      one_pair(:two, :five, :ace, :seven),
      one_pair(:three, :five, :king, :seven)
    )
  end

  test "baz 3" do
    assert_best_hand(
      two_pair(:eight, :six, :ace),
      two_pair(:nine, :five, :two)
    )
  end

  test "baz 4" do
    assert_best_hand(
      three_of_a_kind(:eight, :six, :ace),
      three_of_a_kind(:nine, :five, :two)
    )
  end

  test "baz 5" do
    assert_best_hand(
      straight(:two, :three, :four, :five, :six),
      straight(:three, :four, :five, :six, :seven)
    )
  end

  test "baz 6" do
    assert_best_hand(
      flush(:two, :three, :five, :king, :seven),
      flush(:two, :three, :five, :ace, :seven)
    )
  end

  test "baz 7" do
    assert_best_hand(
      full_house(:seven, :king),
      full_house(:five, :ace)
    )
  end

  test "baz 8" do
    assert_best_hand(
      four_of_a_kind(:seven, :ace),
      four_of_a_kind(:eight, :king)
    )
  end

  test "baz 9" do
    assert_best_hand(
      straight_flush(:two, :three, :four, :five, :six),
      straight_flush(:three, :four, :five, :six, :seven)
    )
  end

  test "baz 10" do
    assert_best_hand(
      five_of_a_kind(:two),
      five_of_a_kind(:three)
    )
  end
end

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
      id: uuid1(),
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
       {b, :spades},
       {c, :diamonds},
       {d, :spades},
       {e, :spades}]
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

  test "rank correctly identifies a high card hand" do
    assert_rank(high_card(), :high_card)
  end

  test "rank correctly identifies a one pair hand" do
    assert_rank(one_pair(), :one_pair)
  end

  test "rank correctly identifies a two pair hand" do
    assert_rank(two_pair(), :two_pair)
  end

  test "rank correctly identifies a three of a kind hand" do
    assert_rank(three_of_a_kind(), :three_of_a_kind)
  end

  test "rank correctly identifies a straight hand" do
    assert_rank(straight(), :straight)
  end

  test "rank correctly identifies a flush hand" do
    assert_rank(flush(), :flush)
  end

  test "rank correctly identifies a full house hand" do
    assert_rank(full_house(), :full_house)
  end

  test "rank correctly identifies a four of a kind hand" do
    assert_rank(four_of_a_kind(), :four_of_a_kind)
  end

  test "rank correctly identifies a straight flush hand" do
    assert_rank(straight_flush(), :straight_flush)
  end

  test "rank correctly identifies a five of a kind hand" do
    assert_rank(five_of_a_kind(), :five_of_a_kind)
  end

  defp assert_same_hand(%Hand{ id: id_1 }, %Hand{ id: id_2 }) do
    assert id_1 == id_2
  end

  defp assert_best_hand(loser, winner) do
    [loser, winner]
    |> Rank.best_hand()
    |> Enum.at(0)
    |> assert_same_hand(winner)
  end

  test "best_hand ranks one pair above high card" do
    assert_best_hand(
      high_card(),
      one_pair()
    )
  end

  test "best_hand ranks straight above three of a kind" do
    assert_best_hand(
      three_of_a_kind(),
      straight()
    )
  end

  test "best_hand ranks flush above straight" do
    assert_best_hand(
      straight(),
      flush()
    )
  end

  test "best_hand ranks four of a kind above flush" do
    assert_best_hand(
      flush(),
      four_of_a_kind()
    )
  end

  test "best_hand ranks straight flush above four of a kind" do
    assert_best_hand(
      four_of_a_kind(),
      straight_flush()
    )
  end

  test "best_hand can break ties between high card hands" do
    assert_best_hand(
      high_card(:king),
      high_card(:ace)
    )
  end

  test "best_hand can break ties between one pair hands" do
    assert_best_hand(
      one_pair(:two, :five, :ace, :seven),
      one_pair(:three, :five, :king, :seven)
    )
  end

  test "best_hand can break ties between two pairs hands" do
    assert_best_hand(
      two_pair(:eight, :six, :ace),
      two_pair(:nine, :five, :two)
    )
  end

  test "best_hand can break ties between three of a kind hands" do
    assert_best_hand(
      three_of_a_kind(:eight, :six, :ace),
      three_of_a_kind(:nine, :five, :two)
    )
  end

  test "best_hand can break ties between straight hands" do
    assert_best_hand(
      straight(:two, :three, :four, :five, :six),
      straight(:three, :four, :five, :six, :seven)
    )
  end

  test "best_hand can break ties between flush hands" do
    assert_best_hand(
      flush(:two, :three, :five, :king, :seven),
      flush(:two, :three, :five, :ace, :seven)
    )
  end

  test "best_hand can break ties between full house hands" do
    assert_best_hand(
      full_house(:five, :ace),
      full_house(:seven, :king)
    )
  end

  test "best_hand can break ties between four of a kind hands" do
    assert_best_hand(
      four_of_a_kind(:seven, :ace),
      four_of_a_kind(:eight, :king)
    )
  end

  test "best_hand can break ties between straight flush hands" do
    assert_best_hand(
      straight_flush(:two, :three, :four, :five, :six),
      straight_flush(:three, :four, :five, :six, :seven)
    )
  end

  test "best_hand can break ties between five of a kind hands" do
    assert_best_hand(
      five_of_a_kind(:two),
      five_of_a_kind(:three)
    )
  end
end

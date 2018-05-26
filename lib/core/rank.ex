defmodule FiveCardDraw.Rank do
  alias FiveCardDraw.Card
  alias FiveCardDraw.Hand
  alias FiveCardDraw.CompareListsUtils

  @ranks [
    :high_card,
    :one_pair,
    :two_pair,
    :three_of_a_kind,
    :straight,
    :flush,
    :full_house,
    :four_of_a_kind,
    :straight_flush,
    :five_of_a_kind,
  ]

  @pair_ranks [
    :high_card,
    :one_pair,
    :two_pair,
    :three_of_a_kind,
    :full_house,
    :four_of_a_kind,
    :five_of_a_kind,
  ]

  @non_pair_ranks [
    :straight,
    :flush,
    :straight_flush,
  ]

  # Utils start
  def rank_int(rank) do
    @ranks
    |> Enum.find_index(fn x -> x == rank end)
  end
  # Utils end

  # Pair style functionality start
  defp sort_pairs({length_a, rank_a}, {length_b, rank_b}) when length_a == length_b do
    Card.rank_int(rank_a) >= Card.rank_int(rank_b)
  end

  defp sort_pairs({length_a, _rank_a}, {length_b, _rank_b}) do
    length_a >= length_b
  end

  defp pairs(cards) do
    cards
    |> Enum.group_by(fn x -> x.rank end)
    |> Enum.map(fn ({rank, group}) -> {length(group), rank} end)
    |> Enum.sort(&sort_pairs/2)
  end

  defp pair_rank([5]), do: :five_of_a_kind
  defp pair_rank([4, 1]), do: :four_of_a_kind
  defp pair_rank([3, 2]), do: :full_house
  defp pair_rank([3, 1, 1]), do: :three_of_a_kind
  defp pair_rank([2, 2, 1]), do: :two_pair
  defp pair_rank([2, 1, 1, 1]), do: :one_pair
  defp pair_rank([1, 1, 1, 1, 1]), do: :high_card

  defp pair_rank(cards) do
    cards
    |> pairs()
    |> Enum.map(fn ({length, _rank}) -> length end)
    |> pair_rank()
  end

  defp max_pair_style_hand(%Hand{ cards: cards }) do
    cards
    |> pairs()
    |> Enum.map(fn ({_length, rank}) -> Card.rank_int(rank) end)
  end

  defp pair_tie_break(hands) do
    hands
    |> CompareListsUtils.max_by(&max_pair_style_hand/1)
  end
  # Pair style functionality end

  # Non pair style functionality start
  defp flush?([%Card{ suit: s }, %Card{ suit: s }, %Card{ suit: s }, %Card{ suit: s }, %Card{ suit: s }]), do: true
  defp flush?(_cards), do: false

  defp ints_stepwise?([_a]), do: true
  defp ints_stepwise?([a | rest]) do
    if a + 1 == List.first(rest) do
      ints_stepwise?(rest)
    else
      false
    end
  end

  defp straight?(cards) do
    cards
    |> Enum.map(&Card.rank_int/1)
    |> Enum.sort()
    |> ints_stepwise?()
  end

  defp non_pair_rank(cards) when is_list(cards) do
    non_pair_rank(%{
      flush?: flush?(cards),
      straight?: straight?(cards)
    })
  end

  defp non_pair_rank(%{ flush?: true, straight?: true }), do: :straight_flush
  defp non_pair_rank(%{ straight?: true }), do: :straight
  defp non_pair_rank(%{ flush?: true }), do: :flush
  defp non_pair_rank(_info), do: nil

  defp non_pair_tie_break(hands) do
    hands
    |> CompareListsUtils.max_by(&Hand.card_rank_ints/1)
  end
  # Non pair style functionality start

  # Rank functionality start
  defp valid_ranks(cards) do
    [
      pair_rank(cards),
      non_pair_rank(cards)
    ]
  end

  def rank(%Hand{ cards: cards }) do
    cards
    |> valid_ranks()
    |> Enum.reject(&is_nil/1)
    |> Enum.max_by(&rank_int/1)
  end
  # Rank functionality end

  # Best hand functionality start
  defp find_winners(hands) do
    hands
    |> Enum.group_by(&rank/1)
    |> Enum.max_by(fn ({rank, _hands}) -> rank_int(rank) end)
  end

  defp break_ties({_rank, [hand]}), do: [hand]
  defp break_ties({rank, hands}) when rank in @non_pair_ranks, do: non_pair_tie_break(hands)
  defp break_ties({rank, hands}) when rank in @pair_ranks, do: pair_tie_break(hands)

  def best_hand(hands) do
    hands
    |> find_winners()
    |> break_ties()
  end
  # Best hand functionality end
end

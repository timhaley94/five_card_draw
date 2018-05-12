defmodule FiveCardDraw.Rank do
  alias FiveCardDraw.Card
  alias FiveCardDraw.Hand

  @ranks [
    :five_of_a_kind,
    :straight_flush,
    :four_of_a_kind,
    :full_house,
    :flush,
    :straight,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card,
  ]

  # Pair style functionality start
  defp pairs(cards) do
    cards
    |> Enum.chunk_by(fn x -> x.rank end)
    |> Enum.map(&length/1)
    |> Enum.sort()
  end

  defp best_pair_rank([5]), do: :five_of_a_kind
  defp best_pair_rank([4, 1]), do: :four_of_a_kind
  defp best_pair_rank([3, 2]), do: :full_house
  defp best_pair_rank([3|_rest]), do: :three_of_a_kind
  defp best_pair_rank([2, 2, 1]), do: :two_pair
  defp best_pair_rank([2|_rest]), do: :one_pair
  defp best_pair_rank(_matches), do: nil

  defp pair_rank(cards) do
    cards
    |> pairs()
    |> best_pair_rank()
  end
  # Pair style functionality end

  # Flush functionality start
  defp flush?([{s, _}, {s, _}, {s, _}, {s, _}, {s, _}]), do: true
  defp flush?(_cards), do: false
  # Flush functionality end

  # Straight functionality start
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
  # Straight functionality end

  defp best_non_pair_rank(%{ flush?: true, straight?: true }), do: :straight_flush
  defp best_non_pair_rank(%{ straight?: true }), do: :straight
  defp best_non_pair_rank(%{ flush?: true }), do: :flush
  defp best_non_pair_rank(_info), do: nil

  defp non_pair_rank(cards) do
    best_non_pair_rank(%{
      flush?: flush?(cards),
      straight?: straight?(cards)
    })
  end

  defp valid_ranks(cards) do
    [
      pair_rank(cards),
      non_pair_rank(cards)
    ]
  end

  defp best_rank(ranks) do
    @ranks
    |> Enum.find(:high_card, fn(x) -> Enum.member?(ranks, x) end)
  end

  def rank(%Hand{ cards: cards }) do
    cards
    |> valid_ranks()
    |> Enum.reject(&is_nil/1)
    |> best_rank()
  end
end
